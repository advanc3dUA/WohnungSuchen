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
        networkManager.fetchHtmlString(urlString: apartmentLink) { htmlString in
            guard let htmlString = htmlString else {
                completion(.failure(NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse SAGA apartment htmlString"])))
                return
            }
            do {
                let doc = try SwiftSoup.parse(htmlString)
                if let immomioLink = try? doc.select("a[href^=\"https://rdr.immomio.com\"]").first()?.attr("href") {
                    completion(.success(immomioLink))
                } else {
                    completion(.failure(NSError(domain: "", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Couldn't find immomioLink"])))
                }
            } catch {
                completion(.failure(NSError(domain: "", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse doc for apartment"])))
            }
        }
    }

}
