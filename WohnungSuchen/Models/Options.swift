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

final class Options {
    var roomsMin: Int
    var roomsMax: Int
    var areaMin: Int
    var areaMax: Int
    var rentMin: Int
    var rentMax: Int
    var updateTime: Int
    var soundIsOn: Bool
    var landlords: [Provider: Bool]

    init() {
        self.roomsMin = 0
        self.roomsMax = 0
        self.areaMin = 0
        self.areaMax = 0
        self.rentMin = 0
        self.rentMax = 0
        self.updateTime = 30
        self.soundIsOn = true
        self.landlords = DefaultOptions.landlords
    }

    func loadSavedDefaults() {
        roomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int ?? DefaultOptions.roomsMin
        roomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int ?? DefaultOptions.roomsMax
        areaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int ?? DefaultOptions.areaMin
        areaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int ?? DefaultOptions.areaMax
        rentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int ?? DefaultOptions.rentMin
        rentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int ?? DefaultOptions.rentMax
        updateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int ?? DefaultOptions.updateTime
        soundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool ?? DefaultOptions.soundIsOn

        DefaultOptions.landlords.forEach { (landlord, _) in
            if let defaultLandlordValue = DefaultOptions.landlords[landlord] {
                landlords.updateValue(UserDefaults.standard.object(forKey: landlord.rawValue) as? Bool ?? defaultLandlordValue, forKey: landlord)
            }
        }
    }

    func isEqualToUserDefaults() -> Bool {
        guard let defaultRoomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int,
              let defaultRoomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int,
              let defaultAreaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int,
              let defaultAreaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int,
              let defaultRentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int,
              let defaultRentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int,
              let defaultUpdateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int,
              let defaultSoundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool,
              let defaultLandlords = getLandlordsFromUserDefaults() else { return false }

        return self.roomsMin == defaultRoomsMin && self.roomsMax == defaultRoomsMax &&
        self.areaMin == defaultAreaMin && self.areaMax == defaultAreaMax &&
        self.rentMin == defaultRentMin && self.rentMax == defaultRentMax &&
        self.updateTime == defaultUpdateTime && self.soundIsOn == defaultSoundIsOn && self.landlords == defaultLandlords
    }

    private func getLandlordsFromUserDefaults() -> [Provider: Bool]? {
        var landlordsDict: [Provider: Bool] = [:]
        for (key, _) in DefaultOptions.landlords {
            if let value = UserDefaults.standard.object(forKey: key.rawValue) as? Bool {
                landlordsDict[key] = value
            } else { return nil }
        }
        return landlordsDict
    }

}
