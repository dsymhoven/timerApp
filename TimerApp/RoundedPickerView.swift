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
        let y:CGFloat = 20
        let curveTo:CGFloat = 0
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
        myBezier.close()
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(4.0)
        UIColor(red:0.11, green:0.22, blue:0.19, alpha:1.0).setFill()
        myBezier.fill()
    }
 

}
