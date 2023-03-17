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
    private let apartmentNameSign = "➡️ "
    private let streetSign = "📍 "
    
    private func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: currentTime)
    }
    
    func foundNew(_ apartment: Apartment) -> String {
        let result =    postTime() + startSign + successSign + "Apartment #\(apartment.index):" + "\n" +
                        apartmentNameSign + "\(apartment.title)\n" +
                        descriptionSign + "Rooms: \(apartment.rooms), " + "m2: \(apartment.area), " + "€: \(apartment.rent)" + "\n" +
                        streetSign + "Street: \(apartment.street)" + "\n" +
                        urlSign + "\(apartment.immomioLink)" + "\n"
        return result
    }
    
    func notFound() -> String {
        postTime() + startSign + nothingNewSign + "Nothing new was found" + "\n"
    }
    
    func errorMakingGoogleURL() -> String {
        postTime() + startSign + errorSign + "Error: unable to construct Google Maps URL" + "\n"
    }
}
