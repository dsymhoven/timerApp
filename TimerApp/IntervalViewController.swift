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
    @IBOutlet weak var pickerViewContainer: UIView!
    @IBOutlet weak var IntervalButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var drawView: DrawView!

    // MARK: IBActions
    @IBAction func roundsButtonPressed(_ sender: UIButton) {
        currentLabel = roundsLabel
        pickerData = ["1", "2", "3", "4", "5"]
        hideAndShowPickerView()
    }
    
    @IBAction func IntervalButtonPressed(_ sender: UIButton) {
        currentLabel = elapsedTimeLabel
        pickerData = [15, 30, 45, 60, 75, 90].map {$0.toDisplayFormat()}
        hideAndShowPickerView()
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        currentLabel = elapsedTimeLabel
        pickerData = [15, 30, 45, 60, 90, 120].map {$0.toDisplayFormat()}
        hideAndShowPickerView()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        if pickerViewIsVisible {
            makePickerViewAppear()
        }
    }
    
    // MARK: User functions
    fileprivate func setupUI() {
        elapsedTimeLabel.text = 0.toDisplayFormat()
        pickerViewContainer.layer.cornerRadius = 40
    }
    
    fileprivate func makePickerViewDisappear() {
        pickerViewContainer.alpha = 0.0
        pickerViewContainer.frame.origin.y = UIScreen.main.bounds.height
        pickerViewIsVisible = false
    }
    
    fileprivate func makePickerViewAppear() {
        pickerViewContainer.alpha = 1.0
        guard let tabHeight = tabBarController?.tabBar.frame.size.height else{return}
        pickerViewContainer.frame.origin.y = UIScreen.main.bounds.height - 216 - tabHeight
        pickerView.reloadAllComponents()
        pickerViewIsVisible = true
    }
    
    fileprivate func hideAndShowPickerView() {
        UIView.animate(withDuration: pickerViewIsVisible ? 0.5 : 0, animations: {[weak weakSelf = self] in
            weakSelf?.makePickerViewDisappear()
        }) {(completed) in
            if completed {
                UIView.animate(withDuration: 0.5, animations: {[weak weakSelf = self] in
                    weakSelf?.makePickerViewAppear()
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
