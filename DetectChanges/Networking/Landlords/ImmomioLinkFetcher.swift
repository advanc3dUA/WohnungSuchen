//
//  ImmomioLinkFetcher.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 29.03.2023.
//

import Foundation
import SwiftSoup

class ImmomioLinkFetcher {
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchLink(for apartmentLink: String, completion: @escaping (String) -> Void) {
        var immomioLink = ""
        networkManager.fetchData(urlString: apartmentLink) { htmlString in
            guard let htmlString = htmlString else {
                fatalError("Couldn't parse SAGA apartment htmlString")
            }
            do {
                let doc = try SwiftSoup.parse(htmlString)
                immomioLink = try doc.select("a[href^=\"https://rdr.immomio.com\"]").first()!.attr("href")
            } catch {
                print("Error parsing HTML: \(error)")
            }
            completion(immomioLink)
        }
    }
}
