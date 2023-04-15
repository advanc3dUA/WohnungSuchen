//
//  Options.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import Foundation

struct Options {
    var rooms = Constants.defaultOptions.rooms
    var area = Constants.defaultOptions.area
    var rent = Constants.defaultOptions.rent
    var updateTime: TimeInterval = Constants.defaultOptions.updateTimer
}
