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

        
        let upperLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + CustomDrawingConstants.arcHeight)
        let upperRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.origin.y + CustomDrawingConstants.arcHeight)
        let upperControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.origin.y)
        
        let lowerLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.height - CustomDrawingConstants.lineWidth)
        let lowerRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.height - CustomDrawingConstants.lineWidth)
        let lowerControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - CustomDrawingConstants.arcHeight)
        
        

        let myBezier = UIBezierPath()
        myBezier.move(to: upperLeftPoint)
        myBezier.addQuadCurve(to: upperRightPoint, controlPoint: upperControlPoint)
        myBezier.addLine(to: lowerRightPoint)
        myBezier.addQuadCurve(to: lowerLeftPoint, controlPoint: lowerControlPoint)
        myBezier.close()
        context?.setLineWidth(CustomDrawingConstants.lineWidth)
        UIColor.Background.customViewBackground.setFill()
        myBezier.fill()

        context?.setStrokeColor(UIColor.Background.componentsBackground.cgColor)
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
