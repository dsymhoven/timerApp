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
        let upperLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + 20)
        let upperRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.origin.y + 20)
        let upperControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.origin.y)
        
        let lowerLeftPoint = CGPoint(x: self.bounds.origin.x, y: self.bounds.height)
        let lowerRightPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        let lowerControlPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - 20)
        
        
        
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor(red:0.02, green:0.84, blue:0.63, alpha:1.0).cgColor)
        context?.move(to: upperLeftPoint)
        context?.addQuadCurve(to: upperRightPoint,
                              control: upperControlPoint)
        context?.move(to: lowerLeftPoint)
        context?.addQuadCurve(to: lowerRightPoint,
                              control: lowerControlPoint)
        context?.strokePath()
    }


}
