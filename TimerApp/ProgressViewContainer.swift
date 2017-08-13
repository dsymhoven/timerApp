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
        let totalTime = numberOfRounds * lengthOfInterval + (numberOfRounds - 1) * lengthOfPause
        let pauseWidth = (self.bounds.width / CGFloat(totalTime)) * CGFloat(lengthOfPause)
        let intervalWidth = (self.bounds.width / CGFloat(totalTime)) * CGFloat(lengthOfInterval)
        
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.Background.componentsBackground.cgColor)
        
        for rounds in 1..<numberOfRounds {
            let intervalPointLow = CGPoint(x: CGFloat(rounds) * intervalWidth + CGFloat(rounds - 1) * pauseWidth, y: self.bounds.height / 2 + lineHeight / 2)
            let intervalPointTop = CGPoint(x: CGFloat(rounds) * intervalWidth + CGFloat(rounds - 1) * pauseWidth, y: self.bounds.height / 2 - lineHeight / 2)
            let pausePointLow = CGPoint(x: intervalPointLow.x + pauseWidth, y: self.bounds.height / 2 + 1)
            let pausePointTop = CGPoint(x: intervalPointTop.x + pauseWidth, y: self.bounds.height / 2 - 1)
            context?.move(to: pausePointLow)
            context?.addLine(to: pausePointTop)
            context?.move(to: intervalPointLow)
            context?.addLine(to: intervalPointTop)
            context?.strokePath()
        }
    }
}
