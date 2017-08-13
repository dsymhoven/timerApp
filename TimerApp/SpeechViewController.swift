//
//  SpeechViewController.swift
//  TimerApp
//
//  Created by David Symhoven on 26.05.16.
//  Copyright © 2016 David Symhoven. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds
import Toaster


class SpeechViewController: UIViewController {

    // MARK-: Properties
    var totalPause: Int?
    let pickerData : [String] = ["30", "45", "60", "90", "120", "150", "180"]
    fileprivate var timer = Timer()
    fileprivate var timeElapsed : Int = 0
    fileprivate var timeRemaining : Int = 0
    fileprivate var isGrantedNotificationAccess: Bool = false
    fileprivate let speaker = Speaker()
    
    fileprivate var displayValue : Int{
        set{
            elapsedTimeLabel.text = newValue.toDisplayFormat()
        }
        get{
            return Int(elapsedTimeLabel.text!)!
        }
    }
    
    // MARK-: Outlets
    @IBAction func toggleTimer(_ sender: UIButton) {
        sender.isSelected ? stopTimer() : startTimer()
    }
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!

    
    // MARK: public user functions (API)
    func stopTimer() {
        #if DEBUG
            Toast(text: "\(#function)").show()
        #endif
        resetTimer()
        displayValue = 0
        enablePickerView()
        startStopButton.isSelected = false
    }
    
    func startTimer() {
        #if DEBUG
            Toast(text: "\(#function)").show()
        #endif
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        disablePickerView()
        removeAllDeliveredNotifications()
        startStopButton.isSelected = true
    }
    
    func resetTimer(){
        timer.invalidate()
        timeElapsed = 0
        enablePickerView()
        startStopButton.isSelected = false
    }
    
    // MARK-: private user functions
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
    
    
    @objc private func updateLabel(){
        if totalPause != nil{
            timeRemaining = totalPause! - timeElapsed
            displayValue = timeRemaining
            timeElapsed += 1
            switch(timeRemaining){
            case 15:
                speaker.say(text: "get ready")
                speaker.vibrate()
            case 1...5:
                speaker.say(text: "\(timeRemaining)")
            case 0:
                resetTimer()
                speaker.vibrate()
                setupAndScheduleNotificationActions()
            default: break
            }
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
    
    private func setupToastView(){
        ToastView.appearance().backgroundColor = UIColor.red
    }
    
    
    // MARK: Life Cylcle
    override func viewWillDisappear(_ animated: Bool) {
        removeAllDeliveredNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        totalPause = Int(pickerData[0])
        displayValue = totalPause!

        setupToastView()
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                self.isGrantedNotificationAccess = true
            }
        
        bannerView.adUnitID = PrivateConstants.adMobBannerId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

// MARK-: Extensions

extension SpeechViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
        case NotificationConstants.actionIdentifier: startTimer()
        default: break
        }
        completionHandler()
    }
}

extension SpeechViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
}

extension SpeechViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let newPause = Int(pickerData[row]){
            totalPause = newPause
            displayValue = newPause
        }
        else{
            elapsedTimeLabel.text = "Could not display data!"
        }
        
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
        return PickerViewConstants.rowHeight
    }

}



