//
//  Constants.swift
//  TimerApp
//
//  Created by David Symhoven on 19.05.17.
//  Copyright © 2017 David Symhoven. All rights reserved.
//

import Foundation
import UIKit


struct PickerViewConstants {
    static let alphaDisabled: CGFloat = 0.6
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
