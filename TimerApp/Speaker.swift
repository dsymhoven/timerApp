//
//  Speaker.swift
//  TimerApp
//
//  Created by David Symhoven on 29.07.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import Foundation
import AVFoundation
import Toaster

class Speaker: NSObject {
    // MARK: Properties
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    fileprivate let speechSynthesizer = AVSpeechSynthesizer()
    
    // MARK: private user functions
    private func activateAudioSession() {
        print("\(#function)")
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
            try audioSession.setActive(true)
        }
        catch let error as NSError {
            Toast(text: "An error occured while activating an audioSession").show()
            print(error)
        }
    }
    
    private func deactivateAudioSession() {
        print("\(#function)")
        do {
            try audioSession.setActive(false)
        }
        catch let error as NSError {
            Toast(text: "An error occured while deactivating the audioSession").show()
            print(error)
        }
    }
    
    private func setUtteranceProperties(_ utterance: AVSpeechUtterance){
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
    }
    
    // MARK: public API
    /// lets the device vibrate once
    func vibrate(){
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
    }
    
    /// lets Siri say something to the user
    /// - parameter text: the text you want Siri to say
    /// - info: activating and deactivting an audio session is handled for you
    func say(text: String) {
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: text)
        setUtteranceProperties(utterance)
        speechSynthesizer.speak(utterance)
//        deactivateAudioSession()
    }
}

extension Speaker: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        deactivateAudioSession()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        deactivateAudioSession()
    }
}
