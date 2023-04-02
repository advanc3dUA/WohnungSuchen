//
//  Saga.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation
import SwiftSoup

class Saga: Landlord {
    private let networkManager: NetworkManager
    private let immomioLinkFetcher: ImmomioLinkFetcher
    private let searchURLString = "https://www.saga.hamburg/immobiliensuche?type=wohnungen"
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.immomioLinkFetcher = ImmomioLinkFetcher(networkManager: networkManager)
    }
    
    func getApartmentsList(completion: @escaping ([Apartment]) -> Void) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        
        networkManager.fetchHtmlString(urlString: searchURLString) {[unowned self] htmlString in
            guard let htmlString = htmlString else {
                fatalError("Can't get htmlString for SAGA")
            }
            do {
                let doc = try SwiftSoup.parse(htmlString)
                let apartments = try doc.select("div.teaser3")
                for apartment in apartments {
                    if let link = try? apartment.select("a").first(),
                       let href = try? link.attr("href"),
                       let title = try? link.select("h3").first()?.text(),
                       let roomInfo = try? link.select("span.ft-semi:contains(Zimmer:)").first()?.parent()?.text(),
                       let rooms = extractInteger(from: roomInfo, forKey: "Zimmer: "),
                       let area = extractInteger(from: roomInfo, forKey: "Fläche: "),
                       let rent = extractInteger(from: roomInfo, forKey: "Gesamtmiete: "),
                       let street = try? link.select("span.ft-semi:contains(Straße:)").first()?.parent()?.text() {
                        var newApartment = Apartment(title: title,
                                                       link: "https://www.saga.hamburg" + href,
                                                       street: dropPrefix(for: street),
                                                       rooms: rooms,
                                                       area: area,
                                                       rent: rent
                        )
                        dispatchGroup.enter()
                        immomioLinkFetcher.fetchLink(for: newApartment.link) { immomioLink in
                            newApartment.immomioLink = immomioLink
                            currentApartments.append(newApartment)
                            dispatchGroup.leave()
                        }
                    }
                }
            } catch { print("Error parsing HTML: \(error)") }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(currentApartments)
            }
        }
    }
    
    private func extractInteger(from string: String, forKey key: String) -> Int? {
        let keyIndex = string.range(of: key)?.upperBound ?? string.startIndex
        let substring = string[keyIndex..<string.endIndex]
        let integerSubstring = substring.split(whereSeparator: { !"-0123456789".contains($0) }).first ?? ""
        return Int(integerSubstring)
    }
    
    private func dropPrefix(for street: String) -> String {
        let prefixToDrop = "Straße: "
        let streetWithoutPrefix = street.map { $0 }.dropFirst(prefixToDrop.count)
        return String(streetWithoutPrefix)
    }
}
