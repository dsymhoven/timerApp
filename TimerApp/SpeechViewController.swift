//
//  SpeechViewController.swift
//  TimerApp
//
//  Created by David Symhoven on 26.05.16.
//  Copyright © 2016 David Symhoven. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
import GoogleMobileAds


class SpeechViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {

    // MARK: Properties
    
    var totalPause: Int?
    var timer = Timer()
    var timeElapsed : Int = 0
    var timeRemaining : Int = 0
    let audioSession = AVAudioSession.sharedInstance()
    var backgroundTaskIdentifier : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    let speechSynthesizer = AVSpeechSynthesizer()
    let pickerData : [String] = ["30", "45", "60", "90", "120", "150", "180"]
    var isGrantedNotificationAccess: Bool = false
    
    var displayValue : Int{
        set{
            elapsedTimeLabel.text = String(newValue) + NSLocalizedString("SECONDS_SHORT", comment: "seconds")
        }
        get{
            return Int(elapsedTimeLabel.text!)!
        }
    }
    
    // MARK: Outlets
    @IBAction func dismissView(_ segue: UIStoryboardSegue) {
        // needed to dismiss the about view in storyboard
    }
    
    @IBAction func toggleTimer(_ sender: UIButton) {
        if (sender.isSelected) {
            stopTimer()
            
        }else{
            startTimer()

        }
    }

    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!

    
    // MARK: Delegate methods
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
            case NotificationConstants.actionIdentifier: startTimer()
            default: break
        }
        completionHandler()
    }
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let totalPause = Int(pickerData[row]){
            displayValue = totalPause
        }
        else{
            elapsedTimeLabel.text = "Could not display data!"
        }
        
    }
    
    
    internal func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row] + " " + NSLocalizedString("SECONDS_SHORT", comment: "seconds")
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 24), NSForegroundColorAttributeName:UIColor.white])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .center
        
        // hide picker view selection lines
        // pickerView.showsSelectionIndicator is pre iOS 7 only
        pickerView.subviews[1].isHidden = true
        pickerView.subviews[2].isHidden = true
        
        return pickerLabel
    }
    
    
    internal func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PickerViewConstants.rowHeight
    }
    

    
    // MARK: User functions
    private func setupAndScheduleNotificationActions(){
        
            if isGrantedNotificationAccess{
                let notificationCenter = UNUserNotificationCenter.current()
            
                let startTimerAction = UNNotificationAction(identifier: NotificationConstants.actionIdentifier, title: NotificationConstants.actionTitle, options: [])
            
                let category = UNNotificationCategory(identifier: NotificationConstants.categoryIdentifier, actions: [startTimerAction], intentIdentifiers: [], options: [])
                notificationCenter.setNotificationCategories([category])
            
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = NSLocalizedString("CONTENT_TITLE", comment: "Tells you that you was awesome and that you should enjoy your pause")
                notificationContent.body = NSLocalizedString("CONTENT_BODY", comment: "Asks you if you want to take the same pause as before, or if you want to set a new timer")
                notificationContent.categoryIdentifier = NotificationConstants.categoryIdentifier

            
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: NotificationConstants.triggerTimeInterval, repeats: false)
            
                let notificationRequest = UNNotificationRequest(identifier: NotificationConstants.requestIdentifier, content: notificationContent, trigger: trigger)
                notificationCenter.add(notificationRequest) { (error) in
                    notificationCenter.delegate = self
                    print(error as Any)}
        }
    }
    

    
    private func removeAllDeliveredNotifications(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    
    func stopTimer() {
        resetTimer()
        elapsedTimeLabel.text = NSLocalizedString("TIMER_STOPPED", comment: "Stopped!")
        deactivateAudioSession()
        enablePickerView()
        startStopButton.isSelected = false
        endBackgroundTask(backgroundTaskIdentifier)
    }
    
    func startTimer() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask() {[weak weakSelf = self] in
            weakSelf?.endBackgroundTask((weakSelf?.backgroundTaskIdentifier)!)
            weakSelf?.removeAllDeliveredNotifications()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        disablePickerView()
        removeAllDeliveredNotifications()
        startStopButton.isSelected = true
        
    }
    
    
    
    private func vibrate(){
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
    }
    
    private func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier){
        if identifier != UIBackgroundTaskInvalid{
            UIApplication.shared.endBackgroundTask(identifier)
            backgroundTaskIdentifier = UIBackgroundTaskInvalid
            print("background task stopped")
        }

    }
    
    @objc private func updateLabel(){
        if totalPause != nil{
            timeRemaining = totalPause! - timeElapsed
            displayValue = timeRemaining
            timeElapsed += 1
            switch(timeRemaining){
            case 15:
                tellUserToGetReady()
                vibrate()
            case 13: deactivateAudioSession()
            case 1...5:
                countDown()
            case 0:
                resetTimer()
                deactivateAudioSession()
                vibrate()
                setupAndScheduleNotificationActions()
                elapsedTimeLabel.text = NSLocalizedString("GO", comment: "Go!")
            default: break
            }
        }


    }
    
    private func setUtteranceProperties(_ utterance: AVSpeechUtterance){
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
    }
    
    private func tellUserToGetReady(){
        
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: "get ready")
        setUtteranceProperties(utterance)
        speechSynthesizer.speak(utterance)
    }
    
    private func countDown(){
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: String(timeRemaining))
        setUtteranceProperties(utterance)
        speechSynthesizer.speak(utterance)
        
    }
    
    func resetTimer(){
        timer.invalidate()
        timeElapsed = 0
        enablePickerView()
        startStopButton.isSelected = false
    }
    
    private func deactivateAudioSession(){
        print("deactivate audioSession")
        do{
            try audioSession.setActive(false)
        }
        catch let error as NSError{
            print("An error occured while deactivating audioSession!")
            print(error)
        }
    }
    
    private func activateAudioSession() {
        print("activate audioSession")
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
            try audioSession.setActive(true)
        }
        catch let error as NSError{
            print("An error occured while activating an audioSession")
            print(error)
        }
    }
    
    private func disablePickerView(){
        pickerView.isUserInteractionEnabled = false
        pickerView.alpha = PickerViewConstants.alphaDisabled
    }
    
    private func enablePickerView(){
        pickerView.isUserInteractionEnabled = true
        pickerView.alpha = PickerViewConstants.alphaEnabled
    }
    
    // MARK: Life Cylcle
    override func viewWillDisappear(_ animated: Bool) {
        
        print("View will unload")
        deactivateAudioSession()
        endBackgroundTask(backgroundTaskIdentifier)
        removeAllDeliveredNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        totalPause = Int(pickerData[0])
        // set current selected pause as big label
        displayValue = totalPause!

        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                self.isGrantedNotificationAccess = true
            }
        
        bannerView.adUnitID = PrivateConstants.adMobBannerId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    



}
