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
    
    func fetchLink(for apartmentLink: String, completion: @escaping (Result<String, AppError>) -> Void) {
        networkManager.fetchHtmlString(urlString: apartmentLink) { result in
            switch result {
            case .success(let htmlString):
                guard let doc = try? SwiftSoup.parse(htmlString) else {
                    completion(.failure(AppError.immomioLinkError(.docCreationFailed)))
                    return
                }
                
                if let immomioLink = try? doc.select("a[href^=\"https://rdr.immomio.com\"]").first()?.attr("href") {
                    completion(.success(immomioLink))
                } else {
                    completion(.failure(AppError.immomioLinkError(.linkExtractionFailed)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
