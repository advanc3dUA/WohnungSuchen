//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation
import SwiftSoup

class NetworkManager {
    private var searchURLString = "https://www.saga.hamburg/immobiliensuche?type=wohnungen"
    private var previousApartments = [Apartment]()
    
    public func start(completion: @escaping ([Apartment]) -> ()) {
        fetchData(urlString: searchURLString) { [unowned self] htmlString in
            guard let htmlString = htmlString else { return }
            let currentApartments = getApartments(for: htmlString).filter { apartment in
                apartment.rooms >= ApartmentFilter.shared.filterModel.rooms
            }
            let newApartments = comparePreviousApartments(with: currentApartments)
            previousApartments = currentApartments
            
            if newApartments.count > 0 {
                var apartmentsWithImmmoLink = [Apartment]()
                let group = DispatchGroup()
                var apartmentIndex = 0
                
                newApartments.forEach { newApartment in
                    group.enter()
                    fetchData(urlString: newApartment.link) {[unowned self] htmlString in
                        defer { group.leave() }
                        guard let htmlString = htmlString else { return }
                        var updatedApartment = newApartment
                        updatedApartment.immomioLink = getImmomioLink(for: htmlString)
                        updatedApartment.index = apartmentIndex
                        apartmentsWithImmmoLink.append(updatedApartment)
                        apartmentIndex += 1
                    }
                }
                group.notify(queue: .main) {
                    completion(apartmentsWithImmmoLink)
                }
            } else {
                completion([])
            }
        }
    }
    
    private func fetchData(urlString: String, completion: @escaping (String?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let htmlString = String(decoding: data, as: UTF8.self)
            
            completion(htmlString)
        }
        task.resume()
    }
    
    private func getApartments(for htmlString: String) -> [Apartment] {
        var currentApartments = [Apartment]()
        
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
                    let apartmentModel = Apartment(title: title,
                                                   link: "https://www.saga.hamburg" + href,
                                                   street: dropPrefix(for: street),
                                                   rooms: rooms,
                                                   area: area,
                                                   rent: rent
                    )
                    
                    currentApartments.append(apartmentModel)
                }
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        return currentApartments
    }
    
    private func getImmomioLink(for htmlString: String) -> String {
        var immomioLink = ""
        do {
            let doc = try SwiftSoup.parse(htmlString)
            immomioLink = try doc.select("a[href^=\"https://rdr.immomio.com\"]").first()!.attr("href")
        } catch {
            print("Error parsing HTML: \(error)")
        }
        return immomioLink
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment]) -> [Apartment] {
        return currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.link == apartment.link })
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
