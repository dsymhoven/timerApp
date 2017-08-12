//
//  DrawView.swift
//  TimerApp
//
//  Created by David Symhoven on 30.07.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import UIKit

class DrawView: UIView {

    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let lineWidth = CGFloat(4.0)
        let upperLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + 20)
        let upperRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.origin.y + 20)
        let upperControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.origin.y)
        
        let lowerLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.height - lineWidth)
        let lowerRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.height - lineWidth)
        let lowerControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - 20)
        
        

        let myBezier = UIBezierPath()
        myBezier.move(to: upperLeftPoint)
        myBezier.addQuadCurve(to: upperRightPoint, controlPoint: upperControlPoint)
        myBezier.addLine(to: lowerRightPoint)
        myBezier.addQuadCurve(to: lowerLeftPoint, controlPoint: lowerControlPoint)
        myBezier.close()
        context?.setLineWidth(lineWidth)
        UIColor(red:0.11, green:0.22, blue:0.19, alpha:1.0).setFill()
        myBezier.fill()

        context?.setStrokeColor(UIColor(red:0.02, green:0.84, blue:0.63, alpha:1.0).cgColor)
        context?.strokePath()
        context?.move(to: upperLeftPoint)
        context?.addQuadCurve(to: upperRightPoint,
                              control: upperControlPoint)
        context?.move(to: lowerLeftPoint)
        context?.addQuadCurve(to: lowerRightPoint,
                              control: lowerControlPoint)
        context?.strokePath()
        
    }


}
