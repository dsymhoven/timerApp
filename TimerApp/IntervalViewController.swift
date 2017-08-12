//
//  IntervalViewController.swift
//  TimerApp
//
//  Created by David Symhoven on 29.07.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import UIKit

enum buttonTitle: String {
    case rounds = "Rounds"
    case interval = "Interval"
    case pause = "Pause"
}

class IntervalViewController: UIViewController {

    // MARK: Properties
    fileprivate var pickerData = ["1", "2", "3", "4", "5"]
    fileprivate var numberOfRounds: Int?
    fileprivate var lengthOfInterval: Int?
    fileprivate var lenghtOfPause: Int?
    fileprivate var pickerViewIsVisible = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    fileprivate var currentLabel: UILabel?
    fileprivate var currentButton: UIButton?
    
    // MARK: IBOutlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var roundsButton: UIButton!
    @IBOutlet weak var pickerViewContainer: RoundedPickerView!
    @IBOutlet weak var IntervalButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var startStopButton: UIButton!

    // MARK: IBActions
    @IBAction func roundsButtonPressed(_ sender: UIButton) {
        hideAndShowPickerView(sender: sender)
        currentButton = sender
        pickerData = ["1", "2", "3", "4", "5"]
        sender.isSelected = !sender.isSelected
        roundsButton.setBackgroundImage(#imageLiteral(resourceName: "setupButtonBase-selected"), for: .selected)
        IntervalButton.isSelected = false
        PauseButton.isSelected = false

    }
    
    @IBAction func IntervalButtonPressed(_ sender: UIButton) {
        hideAndShowPickerView(sender: sender)
        currentButton = sender
        pickerData = [15, 30, 45, 60, 75, 90].map {$0.toDisplayFormat()}
        sender.isSelected = !sender.isSelected
        IntervalButton.setBackgroundImage(#imageLiteral(resourceName: "setupButtonBase-selected"), for: .selected)
        roundsButton.isSelected = false
        PauseButton.isSelected = false
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        hideAndShowPickerView(sender: sender)
        currentButton = sender
        pickerData = [15, 30, 45, 60, 90, 120].map {$0.toDisplayFormat()}
        sender.isSelected = !sender.isSelected
        PauseButton.setBackgroundImage(#imageLiteral(resourceName: "setupButtonBase-selected"), for: .selected)
        roundsButton.isSelected = false
        IntervalButton.isSelected = false
    }
    
    // MARK: User functions
    fileprivate func setupUI() {
        elapsedTimeLabel.text = 0.toDisplayFormat()
        roundsButton.layer.cornerRadius = roundsButton.bounds.width / 2
        roundsButton.setTitle(buttonTitle.rounds.rawValue, for: .normal)
        IntervalButton.layer.cornerRadius = IntervalButton.bounds.width / 2
        IntervalButton.setTitle(buttonTitle.interval.rawValue, for: .normal)
        PauseButton.layer.cornerRadius = PauseButton.bounds.width / 2
        PauseButton.setTitle(buttonTitle.pause.rawValue, for: .normal)
    }
    
    
    fileprivate func hidePickerView() {
        pickerViewContainer.frame.origin.y = UIScreen.main.bounds.height
        pickerViewIsVisible = false
    }
    
    fileprivate func showPickerView() {
        guard let tabHeight = tabBarController?.tabBar.frame.size.height else{return}
        pickerViewContainer.frame.origin.y = UIScreen.main.bounds.height - pickerViewContainer.frame.height - tabHeight
        pickerView.reloadAllComponents()
        pickerViewIsVisible = true
    }
    
    fileprivate func hideAndShowPickerView(sender: UIButton) {
        UIView.animate(withDuration: pickerViewIsVisible ? 0.5 : 0, animations: {[weak weakSelf = self] in
            weakSelf?.hidePickerView()
        }) {(completed) in
            if completed && sender.isSelected {
                UIView.animate(withDuration: 0.5, animations: {[weak weakSelf = self] in
                    weakSelf?.showPickerView()
                })
            }
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        setupUI()
    }
    
    // Problem: if the user selects a row of the pickerView the pickerView disappears. Xcode automatically resets all constraints and this method gets called. Since the picker's default constraints are set such that the picker is not visible at first the picker disappears. 
    // Solution: If the picker should be visible show the picker after resetting the constraints
    override func viewDidLayoutSubviews() {
        if pickerViewIsVisible {
            showPickerView()
        }
    }
}


extension IntervalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}

extension IntervalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let button = currentButton, let title = button.currentTitle else {return}
        switch title {
            // todo: use string array to hold pickerData. transform as needed in computed property
            case buttonTitle.rounds.rawValue:
                roundsLabel.text = pickerData[row]
                numberOfRounds = Int(pickerData[row])
            case buttonTitle.interval.rawValue:
                elapsedTimeLabel.text = pickerData[row]
                lengthOfInterval = Int(pickerData[row])
            case buttonTitle.pause.rawValue:
                elapsedTimeLabel.text = pickerData[row]
                lenghtOfPause = Int(pickerData[row])
        default: break
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row] + " "
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
