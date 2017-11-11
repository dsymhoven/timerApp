//
//  Constants.swift
//  TimerApp
//
//  Created by David Symhoven on 19.05.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    static let numberOfRounds = DefaultsKey<Int>("numberOfRounds")
    static let lengthOfPause = DefaultsKey<Int>("lengthOfPause")
    static let lengthOfInterval = DefaultsKey<Int>("lengthOfInterval")
}


struct PickerViewConstants {
    static let alphaDisabled: CGFloat = 0.7
    static let alphaEnabled: CGFloat = 1.0
    static let rowHeight: CGFloat = 46.0
}

struct NotificationConstants {
    static let categoryIdentifier: String = "timerCategory"
    static let requestIdentifier: String = "startOrReset"
    static let actionIdentifier: String = "startTimer"
    static let actionTitle: String = "Start Timer"
    static let triggerTimeInterval: TimeInterval = 10
}

struct CustomDrawingConstants {
    static let lineWidth = CGFloat(4.0)
    static let arcHeight = CGFloat(20)
}

struct ButtonConstants {
    static let topInset = CGFloat(-20)
}



