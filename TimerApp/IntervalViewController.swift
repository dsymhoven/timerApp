//
//  IntervalViewController.swift
//  TimerApp
//
//  Created by David Symhoven on 29.07.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import UIKit

class IntervalViewController: UIViewController {

    // MARK: Properties
    fileprivate var pickerData = ["1", "2", "3", "4", "5"]
    fileprivate var numberOfRounds: Int?
    fileprivate var pickerViewIsVisible = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    fileprivate var currentLabel: UILabel?
    
    // MARK: IBOutlets
    @IBOutlet weak var roundsButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
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
        currentLabel = roundsLabel
        pickerData = ["1", "2", "3", "4", "5"]
        sender.isSelected = !sender.isSelected
        roundsButton.setTitleColor(.red, for: .selected)

    }
    
    @IBAction func IntervalButtonPressed(_ sender: UIButton) {
        hideAndShowPickerView(sender: sender)
        currentLabel = elapsedTimeLabel
        pickerData = [15, 30, 45, 60, 75, 90].map {$0.toDisplayFormat()}
        sender.isSelected = !sender.isSelected
        IntervalButton.setTitleColor(.red, for: .selected)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        hideAndShowPickerView(sender: sender)
        currentLabel = elapsedTimeLabel
        pickerData = [15, 30, 45, 60, 90, 120].map {$0.toDisplayFormat()}
        sender.isSelected = !sender.isSelected
        PauseButton.setTitleColor(.red, for: .selected)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        if pickerViewIsVisible {
            showPickerView()
        }
    }
    
    // MARK: User functions
    fileprivate func setupUI() {
        elapsedTimeLabel.text = 0.toDisplayFormat()
        roundsButton.layer.cornerRadius = roundsButton.bounds.width / 2
        IntervalButton.layer.cornerRadius = IntervalButton.bounds.width / 2
        PauseButton.layer.cornerRadius = PauseButton.bounds.width / 2
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
        guard let label = currentLabel else {return}
        label.text = pickerData[row]
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
