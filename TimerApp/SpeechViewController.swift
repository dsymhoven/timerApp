//
//  SpeechViewController.swift
//  TimerApp
//
//  Created by David Symhoven on 26.05.16.
//  Copyright © 2016 David Symhoven. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Properties
    var totalPause: Int? = 10
    var timer = NSTimer()
    var timeElapsed : Int = 0
    var timeRemaining : Int = 0
    let audioSession = AVAudioSession.sharedInstance()
    var backgroundTaskIdentifier : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    let speechSynthesizer = AVSpeechSynthesizer()
    let pickerData : [String] = ["10","30", "45", "60", "90", "120"]
    
    // MARK: Outlets
    /**
     "startTimer" Button from UI.
     
     Initilizes a timer which invokes the method "updateLabel" each second. Timer will be active in background mode. Therefore
     start a background task with expiration handler. If no time is granted task will be terminated.
     
     Also the pickerView gets disabled
     */
    @IBAction func startTimer(sender: UIButton) {
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            self.endBackgroundTask(self.backgroundTaskIdentifier)
        })
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        disablePickerView()
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    /**
     "stopTimer" Button from UI. 
     
     rests timer, sets elapsedTimeLabel to "Stopped!", deactivates current audioSession, enables pickerView again and ends current background task.
     */
    @IBAction func stopTimer(sender: UIButton) {
        resetTimer()
        elapsedTimeLabel.text = "Stopped!"
        deactivateAudioSession()
        enablePickerView()
        endBackgroundTask(backgroundTaskIdentifier)
    }
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    // MARK: Delegate methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        totalPause = Int(pickerData[row])
    }
    
    // MARK: User functions
    
    func endBackgroundTask(identifier: UIBackgroundTaskIdentifier){
        if identifier != UIBackgroundTaskInvalid{
            UIApplication.sharedApplication().endBackgroundTask(identifier)
            backgroundTaskIdentifier = UIBackgroundTaskInvalid
            print("background task stopped")
        }

    }
    
    func updateLabel(){
        if totalPause != nil{
            timeRemaining = totalPause! - timeElapsed
            elapsedTimeLabel.text = String(timeRemaining)
            timeElapsed += 1
            switch(timeRemaining){
            case 15: tellUserToGetReady()
            case 13: deactivateAudioSession()
            case 1...5: countDown()
            case 0:
                resetTimer()
                deactivateAudioSession()
                endBackgroundTask(backgroundTaskIdentifier)
                elapsedTimeLabel.text = "Go!"
            default: break
            }
        }


    }
    
    func setUtteranceProperties(utterance: AVSpeechUtterance){
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
    }
    
    func tellUserToGetReady(){
        
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: "get ready")
        setUtteranceProperties(utterance)
        speechSynthesizer.speakUtterance(utterance)
    }
    
    func countDown(){
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: String(timeRemaining))
        setUtteranceProperties(utterance)
        speechSynthesizer.speakUtterance(utterance)
        
    }
    
    func resetTimer(){
        timer.invalidate()
        timeElapsed = 0
        enablePickerView()

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
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.DuckOthers)
            try audioSession.setActive(true)
        }
        catch let error as NSError{
            print("An error occured while activating an audioSession")
            print(error)
        }
    }
    
    func disablePickerView(){
        pickerView.userInteractionEnabled = false
        pickerView.alpha = 0.6
    }
    
    func enablePickerView(){
        pickerView.userInteractionEnabled = true
        pickerView.alpha = 1.0
    }
    
    // MARK: Life Cylcle
    override func viewWillDisappear(animated: Bool) {
        
        print("View will unload")
        deactivateAudioSession()
        endBackgroundTask(backgroundTaskIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

    }

}