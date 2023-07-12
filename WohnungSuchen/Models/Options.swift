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
    var landlords: [Landlord]
    
    
    init() {
        roomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int ?? Constants.defaultOptions.roomsMin
        roomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int ?? Constants.defaultOptions.roomsMax
        areaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int ?? Constants.defaultOptions.areaMin
        areaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int ?? Constants.defaultOptions.areaMax
        rentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int ?? Constants.defaultOptions.rentMin
        rentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int ?? Constants.defaultOptions.rentMax
        updateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int ?? Constants.defaultOptions.updateTime
        soundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool ?? Constants.defaultOptions.soundIsOn
        
        let sagaIsOn = UserDefaults.standard.object(forKey: SavingKeys.saga.rawValue) as? Bool ?? Constants.defaultOptions.saga
        let vonoviaIsOn = UserDefaults.standard.object(forKey: SavingKeys.vonovia.rawValue) as? Bool ?? Constants.defaultOptions.vonovia
        landlords = []
        if sagaIsOn {
            appendLandlord(Saga.init())
        }
        if vonoviaIsOn {
            appendLandlord(Vonovia.init())
        }
        print("curr state of landlord: \(landlords)")
        
        removeLandLord(Vonovia.init())
        print("curr state of landlord: \(landlords)")
    }
    
    func appendLandlord<T: Landlord>(_ landlord: T) {
        if let _ = landlords.first(where: { $0 is T }) {
            return
        } else {
            landlords.append(landlord)
        }
    }
    
    func removeLandLord<T: Landlord>(_ landlord: T) {
        landlords.removeAll { $0 is T }
    }
    
    func removeSaga() {
        landlords.removeAll { landlord in
            landlord is Saga
        }
    }
    
    func removeVonovia() {
        landlords.removeAll { landlord in
            landlord is Vonovia
        }
    }
}
