//
//  ProgressViewContainer.swift
//  TimerApp
//
//  Created by David Symhoven on 12.08.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import UIKit

class ProgressViewContainer: UIView {
    
    var numberOfRounds = 4
    var lengthOfPause = 30

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let lineHeight = CGFloat(8)
        
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.Background.componentsBackground.cgColor)
        
        for rounds in 1..<numberOfRounds {
            let pointLow = CGPoint(x: CGFloat(rounds) * (self.bounds.width / CGFloat(numberOfRounds)), y: self.bounds.height / 2 + lineHeight / 2)
            let pointTop = CGPoint(x: CGFloat(rounds) * (self.bounds.width / CGFloat(numberOfRounds)), y: self.bounds.height / 2 - lineHeight / 2)
            context?.move(to: pointLow)
            context?.addLine(to: pointTop)
            context?.strokePath()
        }
    }
}
