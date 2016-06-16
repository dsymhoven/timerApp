//
//  SpeechViewController.swift
//  TimerApp
//
//  Created by David Symhoven on 26.05.16.
//  Copyright © 2016 David Symhoven. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Properties
    var totalPause: Int? = 0
    var timer = NSTimer()
    var timeElapsed : Int = 0
    var timeRemaining : Int = 0
    let audioSession = AVAudioSession.sharedInstance()
    var backgroundTaskIdentifier : UIBackgroundTaskIdentifier?
    let speechSynthesizer = AVSpeechSynthesizer()
    let pickerData : [String] = ["30", "45", "60", "90", "120"]
    
    // MARK: Outlets
    /**
     "startTimer" Button from UI.
     
     Initilizes a timer which  invokes the method "updateLabel" each second. Timer will be active in background mode. Therefore
     Start a background task with expiration handler. If no time is granted task will be terminated.
     */
    @IBAction func startTimer(sender: UIButton) {
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
            textField.resignFirstResponder()
        
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    /**
     "stopTimer" Button from UI. 
     
     rests timer, sets elapsedTimeLabel to "Stopped!" and deactivates current audioSession.
     */
    @IBAction func stopTimer(sender: UIButton) {
        resetTimer()
        elapsedTimeLabel.text = "Stopped!"
        deactivateAudioSession()
    }
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    /**
     Property of the textField in the UI. When Outlet is set, textField delegate is set to self and
     keyboard shows up via "becomeFirstResponder" method.
     */
    @IBOutlet weak var textField: UITextField!
    {
        didSet{
            textField.delegate = self
            textField.becomeFirstResponder()
        }
        
    }
    
    // MARK: Delegate Functions
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != nil{
            totalPause = Int(textField.text!)
            if totalPause == nil{
                elapsedTimeLabel.text = "Wrong Input!"
            }
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // number of columns of picker view
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
        print(pickerData[row])
    }
    // MARK: User functions
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
        
        //let synthesizer = AVSpeechSynthesizer()
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
        //totalPause = 0
        timeElapsed = 0
        

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
    
    // MARK: Life Cylcle
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        textField.resignFirstResponder()
    }

    
    override func viewWillDisappear(animated: Bool) {
        
        print("View will unload")
        deactivateAudioSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

    }

}