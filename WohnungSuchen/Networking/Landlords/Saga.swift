//
//  Saga.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation
import SwiftSoup

final class Saga: Landlord {
    private let immomioLinkFetcher: ImmomioLinkFetcher
    private let networkManager: NetworkManager
    private let searchURLString = "https://www.saga.hamburg/immobiliensuche?type=wohnungen"

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.immomioLinkFetcher = ImmomioLinkFetcher(networkManager: networkManager)
    }

    func fetchApartmentsList(completion: @escaping (Result<[Apartment], AppError>) -> Void) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()

        networkManager.fetchHtmlString(urlString: searchURLString) {[unowned self] result in
            switch result {
            case .success(let htmlString):
                let time = TimeManager.shared.getCurrentTime()
                guard let doc = try? SwiftSoup.parse(htmlString), let apartments = try? doc.select("div.teaser3") else {
                    completion(.failure(AppError.landlordError(.sagaDocCreationFailed)))
                    return
                }
                for apartment in apartments {
                    if let link = try? apartment.select("a").first(),
                       let href = try? link.attr("href"),
                       let title = try? link.select("h3").first()?.text(),
                       let roomInfo = try? link.select("span.ft-semi:contains(Zimmer:)").first()?.parent()?.text(),
                       let details = extractApartmentDetails(from: roomInfo),
                       let street = try? link.select("span.ft-semi:contains(Straße:)").first()?.parent()?.text() {
                        let newApartment = Apartment(time: time,
                                                     title: title,
                                                     internalLink: "https://www.saga.hamburg" + href,
                                                     street: dropPrefix(for: street),
                                                     rooms: details.rooms,
                                                     area: details.area,
                                                     rent: details.rent,
                                                     company: .saga,
                                                     landlord: self
                        )
                        dispatchGroup.enter()
                        currentApartments.append(newApartment)
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(.success(currentApartments))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setExternalLink(for apartment: Apartment, completion: @escaping (Result<Apartment, AppError>) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        var modifiedApartment = apartment

        immomioLinkFetcher.fetchLink(for: apartment.internalLink) { result in
            switch result {
            case .success(let immomioLink):
                modifiedApartment = Apartment(apartment: apartment, with: immomioLink)
            case .failure(let error):
                completion(.failure(error))
            }
            semaphore.signal()
        }

        semaphore.wait()
        completion(.success(modifiedApartment))
    }

    private func extractApartmentDetails(from string: String) -> (rooms: Int, area: Int, rent: Int)? {
        let components = string.components(separatedBy: .whitespacesAndNewlines)

        guard let roomsIndex = components.firstIndex(of: "Zimmer:"), roomsIndex + 2 < components.count else { return nil }
        let roomsString = components[roomsIndex + 1]
        var rooms = Int(roomsString) ?? 0
        if components[roomsIndex + 2].contains("1/2") {
            rooms += 1
        } else if components[roomsIndex + 2].contains("2/2") {
            rooms += 2
        }

        guard let areaIndex = components.firstIndex(of: "Fläche:"), areaIndex + 1 < components.count else { return nil }
        let area = Int(components[areaIndex + 2]) ?? 0

        guard let rentIndex = components.firstIndex(of: "Gesamtmiete:"), rentIndex + 1 < components.count else { return nil }
        let rentString = components[rentIndex + 1].replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        let rentFloat = Float(rentString) ?? 0
        let rent = Int(rentFloat)

        return (rooms: rooms, area: area, rent: rent)
    }

    private func dropPrefix(for street: String) -> String {
        let prefixToDrop = "Straße: "
        let streetWithoutPrefix = street.map { $0 }.dropFirst(prefixToDrop.count)
        return String(streetWithoutPrefix)
    }
}
