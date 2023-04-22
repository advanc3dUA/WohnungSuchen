//
//  Constants.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import Foundation

struct Constants {
    struct defaultOptions {
        static let rooms = (min: 2, max: 3)
        static let area = (min: 40, max: 60)
        static let rent = (min: 300, max: 900)
        static let updateTimer: TimeInterval = 30
        static let alertType: AlertType = .sound
        static let volume: Float = 7.0
    }
}
