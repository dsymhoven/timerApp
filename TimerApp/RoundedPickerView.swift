//
//  RoundedPickerView.swift
//  TimerApp
//
//  Created by David Symhoven on 04.08.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import UIKit

class RoundedPickerView: UIView {


    override func draw(_ rect: CGRect) {
    
        let upperLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + CustomDrawingConstants.arcHeight)
        let upperRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.origin.y + CustomDrawingConstants.arcHeight)
        let upperControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.origin.y)
        let lowerRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        let lowerLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.height)
        
        let myBezier = UIBezierPath()
        myBezier.move(to: upperLeftPoint)
        myBezier.addQuadCurve(to: upperRightPoint, controlPoint: upperControlPoint)
        myBezier.addLine(to: lowerRightPoint)
        myBezier.addLine(to: lowerLeftPoint)
        myBezier.close()
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(CustomDrawingConstants.lineWidth)
        UIColor.Background.customViewBackground.setFill()
        myBezier.fill()
    }
 

}
