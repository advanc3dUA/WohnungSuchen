//
//  Options.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import Foundation

enum SavingKeys: String {
    case roomsMin
    case roomsMax
    case areaMin
    case areaMax
    case rentMin
    case rentMax
    case updateTime
    case soundIsOn
    case saga
    case vonovia
}

final class Options {
    var roomsMin: Int
    var roomsMax: Int
    var areaMin: Int
    var areaMax: Int
    var rentMin: Int
    var rentMax: Int
    var updateTime: Int
    var soundIsOn: Bool
    var landlords: [String:Bool]
    
    init() {
        self.roomsMin = 0
        self.roomsMax = 0
        self.areaMin = 0
        self.areaMax = 0
        self.rentMin = 0
        self.rentMax = 0
        self.updateTime = 30
        self.soundIsOn = true
        self.landlords = [:]
    }
    
    func loadSavedDefaults() {
        roomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int ?? Constants.defaultOptions.roomsMin
        roomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int ?? Constants.defaultOptions.roomsMax
        areaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int ?? Constants.defaultOptions.areaMin
        areaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int ?? Constants.defaultOptions.areaMax
        rentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int ?? Constants.defaultOptions.rentMin
        rentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int ?? Constants.defaultOptions.rentMax
        updateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int ?? Constants.defaultOptions.updateTime
        soundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool ?? Constants.defaultOptions.soundIsOn
        
        landlords = [ SavingKeys.saga.rawValue: UserDefaults.standard.object(forKey: SavingKeys.saga.rawValue) as? Bool ?? Constants.defaultOptions.saga,
                      SavingKeys.vonovia.rawValue: UserDefaults.standard.object(forKey: SavingKeys.vonovia.rawValue) as? Bool ?? Constants.defaultOptions.vonovia
                    ]
    }
}
