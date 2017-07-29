//
//  Extensions.swift
//  TimerApp
//
//  Created by David Symhoven on 29.07.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import Foundation


extension Int {
    func toDisplayFormat() -> String {
        switch self {
        case 0...9: return "00:0" + String(self)
        case 10...59: return "00:" + String(self)
        case 60...69: return "01:0" + String(self-60)
        case 70...119: return "01:" + String(self-60)
        case 120...129: return "02:0" + String(self-120)
        case 130...179: return "02:" + String(self-120)
        case 180: return "03:00"
        default: return "00:00"
        }
    }
}
