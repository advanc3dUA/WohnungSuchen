//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation

class LandlordsManager {
    private var previousApartments = [Apartment]()
    private let immomioLinkFetcher = ImmomioLinkFetcher(networkManager: NetworkManager())
    var landlords: [Landlord] = [Saga(), Vonovia()]
    
    public func start(completion: @escaping ([Apartment]) -> ()) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        for landlord in landlords {
            dispatchGroup.enter()
            landlord.getApartmentsList { apartments in
                currentApartments += apartments
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            comparePreviousApartments(with: currentApartments) { newApartments in
                completion(newApartments)
            }
            previousApartments = currentApartments
        }
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment], completion: @escaping ([Apartment]) -> ()) {
        let dispatchGroup = DispatchGroup()
        var newApartments = currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.internalLink == apartment.internalLink })
        }
        for (index, apartment) in newApartments.enumerated() {
            if apartment.company == .saga {
                dispatchGroup.enter()
                immomioLinkFetcher.fetchLink(for: apartment.internalLink) { immomioLink in
                    newApartments[index].externalLink = immomioLink
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(newApartments)
        }
    }
}
