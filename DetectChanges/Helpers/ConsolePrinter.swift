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
    
    private func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: currentTime)
    }
    
    func foundNew(_ apartment: Apartment) -> String {
        guard let title = apartment.title, let rooms = apartment.rooms, let area = apartment.area, let rent = apartment.rent else {
            return postTime() + startSign + errorSign + "Can't find title for apartment"
        }
        guard let immomioLink = apartment.immomioLink else {
            return postTime() + startSign + errorSign + "Can't find immomioLink for apartment"
        }
        let result =    postTime() + startSign + successSign + "\(title)\n" +
                        postTime() + startSign + descriptionSign + "rooms: \(rooms), " + "m2: \(area), " + "€: \(rent)." + "\n" +
                        postTime() + startSign + urlSign + "\(immomioLink)" + "\n"
        return result
    }
    
    func notFound() -> String {
        postTime() + startSign + nothingNewSign + "Nothing new was found" + "\n"
    }
}
