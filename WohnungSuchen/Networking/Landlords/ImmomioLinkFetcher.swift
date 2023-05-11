//
//  ImmomioLinkFetcher.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 29.03.2023.
//

import Foundation
import SwiftSoup

final class ImmomioLinkFetcher {
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchLink(for apartmentLink: String, completion: @escaping (Result<String, Error>) -> Void) {
        var immomioLink = ""
        networkManager.fetchHtmlString(urlString: apartmentLink) { htmlString in
            guard let htmlString = htmlString else {
                fatalError("Couldn't parse SAGA apartment htmlString")
            }
            do {
                let doc = try SwiftSoup.parse(htmlString)
                immomioLink = try doc.select("a[href^=\"https://rdr.immomio.com\"]").first()!.attr("href")
            } catch {
                print("Error parsing HTML: \(error)")
                completion(.failure(error))
            }
            completion(.success(immomioLink))
        }
    }
}
