//
//  ProgressViewContainer.swift
//  TimerApp
//
//  Created by David Symhoven on 12.08.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import UIKit

class ProgressViewContainer: UIView {
    
    var numberOfRounds = 1
    var lengthOfPause = 1
    var lengthOfInterval = 1

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let lineHeight = CGFloat(8)
        let totalTime = numberOfRounds * (lengthOfPause + lengthOfInterval)
        let pauseWidth = (self.bounds.width / CGFloat(totalTime)) * CGFloat(lengthOfPause)
        
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.Background.componentsBackground.cgColor)
        
        for rounds in 1..<numberOfRounds {
            let pausePointLow = CGPoint(x: CGFloat(rounds) * (self.bounds.width / CGFloat(numberOfRounds)), y: self.bounds.height / 2 + 1)
            let pausePointTop = CGPoint(x: CGFloat(rounds) * (self.bounds.width / CGFloat(numberOfRounds)), y: self.bounds.height / 2 - 1)
            let intervalPointLow = CGPoint(x: pausePointLow.x - pauseWidth, y: self.bounds.height / 2 + lineHeight / 2)
            let intervalPointTop = CGPoint(x: pausePointTop.x - pauseWidth, y: self.bounds.height / 2 - lineHeight / 2)
            context?.move(to: intervalPointLow)
            context?.addLine(to: intervalPointTop)
            context?.move(to: pausePointLow)
            context?.addLine(to: pausePointTop)
            context?.strokePath()
        }
    }
}
