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
}

@propertyWrapper struct UserDefaultsBacked<T> {
    let key: String
    let storage: UserDefaults = .standard
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            let value = storage.object(forKey: key) as? T
            return value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

class Options {
    var roomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int ?? Constants.defaultOptions.roomsMin
    var roomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int ?? Constants.defaultOptions.roomsMax
    var areaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int ?? Constants.defaultOptions.areaMin
    var areaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int ?? Constants.defaultOptions.areaMax
    var rentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int ?? Constants.defaultOptions.rentMin
    var rentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int ?? Constants.defaultOptions.rentMax
    var updateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int ?? Constants.defaultOptions.updateTime
    var soundIsOn: Bool = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool ?? Constants.defaultOptions.soundIsOn
}
