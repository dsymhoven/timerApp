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
    
    // MARK: Outlets

    
    @IBAction func dismissView(_ segue: UIStoryboardSegue) {
        // needed to dismiss the about view in storyboard
    }
    
    @IBAction func toggleTimer(_ sender: UIButton) {
        if (sender.isSelected) {
            stopTimer()
            
        }else{
            //startStopButton = sender
            startTimer()

        }
    }
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    @IBOutlet weak var BannerView: UIView!
    
    // MARK: Delegate methods
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
            case "startTimer": startTimer()
            default: break
        }
        completionHandler()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        totalPause = Int(pickerData[row])
        elapsedTimeLabel.text = "\(totalPause!) " + NSLocalizedString("SECONDS_SHORT", comment: "seconds")
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
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
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 46.0
    }
    

    
    // MARK: User functions
    
    
    func setupAndScheduleNotificationActions(){
        
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            
            let startTimerAction = UNNotificationAction(identifier: "startTimer", title: "Start Timer", options: [])
            let resetTimerAction = UNNotificationAction(identifier: "resetTimer", title: "Reset Timer", options: [])
            
            let category = UNNotificationCategory(identifier: "timerCategory", actions: [startTimerAction, resetTimerAction], intentIdentifiers: [], options: [])
            notificationCenter.setNotificationCategories([category])
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "That was awesome! Now enjoy your pause."
            notificationContent.body = "Same pause again or reset your timer?"
            notificationContent.categoryIdentifier = "timerCategory"

            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let notificationRequest = UNNotificationRequest(identifier: "startOrReset", content: notificationContent, trigger: trigger)
            notificationCenter.add(notificationRequest) { (error) in
                notificationCenter.delegate = self
                print(error)}
            } else {
            // Fallback on earlier versions
        }
    }
    

    
    func cancelAllLocalNotifications(){
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func handleResetTimerNotification(){
        print("ResetTimer Button pressed!")
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
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundTask(self.backgroundTaskIdentifier)
        })
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        disablePickerView()
        cancelAllLocalNotifications()
        startStopButton.isSelected = true
    }
    
    
    
    func vibrate(){
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
    }
    
    func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier){
        if identifier != UIBackgroundTaskInvalid{
            UIApplication.shared.endBackgroundTask(identifier)
            backgroundTaskIdentifier = UIBackgroundTaskInvalid
            print("background task stopped")
        }

    }
    
    func updateLabel(){
        if totalPause != nil{
            timeRemaining = totalPause! - timeElapsed
            elapsedTimeLabel.text = "\(timeRemaining) " + NSLocalizedString("SECONDS_SHORT", comment: "seconds")
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
                elapsedTimeLabel.text = "Go!"
            default: break
            }
        }


    }
    
    func setUtteranceProperties(_ utterance: AVSpeechUtterance){
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
    }
    
    func tellUserToGetReady(){
        
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: "get ready")
        setUtteranceProperties(utterance)
        speechSynthesizer.speak(utterance)
    }
    
    func countDown(){
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: String(timeRemaining))
        setUtteranceProperties(utterance)
        speechSynthesizer.speak(utterance)
        
    }
    
    func resetTimer(){
        timer.invalidate()
        timeElapsed = 0
        enablePickerView()
        startStopButton?.isSelected = false
    }
    
    func deactivateAudioSession(){
        print("deactivate audioSession")
        do{
            try audioSession.setActive(false)
        }
        catch let error as NSError{
            print("An error occured while deactivating audioSession!")
            print(error)
        }
    }
    
    func activateAudioSession() {
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
    
    func disablePickerView(){
        pickerView.isUserInteractionEnabled = false
        pickerView.alpha = 0.6
    }
    
    func enablePickerView(){
        pickerView.isUserInteractionEnabled = true
        pickerView.alpha = 1.0
    }
    
    // MARK: Life Cylcle
    override func viewWillDisappear(_ animated: Bool) {
        
        print("View will unload")
        deactivateAudioSession()
        endBackgroundTask(backgroundTaskIdentifier)
        cancelAllLocalNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        totalPause = Int(pickerData[0])
        // set current selected pause as big label
        elapsedTimeLabel.text = "\(totalPause!) " + NSLocalizedString("SECONDS_SHORT", comment: "seconds")

    }
    



}
