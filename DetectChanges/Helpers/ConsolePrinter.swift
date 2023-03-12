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
    
    private func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: currentTime)
    }
    
    func foundNew(_ apartment: Apartment) -> String {
        guard let title = apartment.title, let url = apartment.link else {
            return postTime() + startSign + errorSign + "Can't find title for apartment"
        }
        guard let immomioLink = apartment.immomioLink else {
            return postTime() + startSign + errorSign + "Can't find immomioLink for apartment"
        }
        return postTime() + startSign + successSign + "\(title)\n" + postTime() + startSign + urlSign + "\(url)" + "\n" + postTime() + startSign + urlSign + "\(immomioLink)" + "\n"
    }
    
    func notFound() -> String {
        postTime() + startSign + nothingNewSign + "Nothing new was found" + "\n"
    }
}
