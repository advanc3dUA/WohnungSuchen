//
//  TimeManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 07.04.2023.
//

import Foundation

struct TimeManager {
    static let shared = TimeManager()
    
    private init() {}
    
    func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: currentTime)
    }
}
