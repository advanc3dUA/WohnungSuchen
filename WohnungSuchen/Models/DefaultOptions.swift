//
//  DefaultOptions.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import Foundation

struct DefaultOptions {
    static let roomsMin = 1
    static let roomsMax = 5
    static let areaMin = 20
    static let areaMax = 120
    static let rentMin = 150
    static let rentMax = 1400
    static let updateTime = 45
    static let soundIsOn = true
    static let landlords: [Provider: Bool] = [.saga: true, .vonovia: true]
}

enum Provider: String {
    case saga = "Saga"
    case vonovia = "Vonovia"

    static func generateProvider(with provider: Provider) -> Landlord {
        switch provider {
        case .saga: Saga()
        case .vonovia: Vonovia()
        }
    }

    static func getProvider(from string: String) -> Provider? {
        return Provider(rawValue: string)
    }
}
