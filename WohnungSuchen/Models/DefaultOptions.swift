//
//  DefaultOptions.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import Foundation

struct DefaultOptions {
    static let roomsMin = 2
    static let roomsMax = 3
    static let areaMin = 40
    static let areaMax = 60
    static let rentMin = 300
    static let rentMax = 900
    static let updateTime = 30
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
