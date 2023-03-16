//
//  ConsolePrinter.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 12.03.2023.
//

import Foundation

struct ConsolePrinter {
    private let startSign = " → "
    private let successSign = "✅ "
    private let nothingNewSign = "☑️ "
    private let errorSign = "❌ "
    private let urlSign = "🔗 "
    private let descriptionSign = "🔍 "
    private let spaces = "                    "
    
    private func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: currentTime)
    }
    
    func foundNew(_ apartment: Apartment) -> String {
        let result =    postTime() + startSign + successSign + "\(apartment.index). " + "\(apartment.title)\n" +
                        spaces + descriptionSign + "rooms: \(apartment.rooms), " + "m2: \(apartment.area), " + "€: \(apartment.rent), " + "\(apartment.street)." + "\n" +
                        spaces + urlSign + "\(apartment.immomioLink)" + "\n"
        return result
    }
    
    func notFound() -> String {
        postTime() + startSign + nothingNewSign + "Nothing new was found" + "\n"
    }
}
