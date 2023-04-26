//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation

class LandlordsManager {
    fileprivate var previousApartments = [Apartment]()
    private var landlords: [Landlord] = [Saga()]
    //, Vonovia()
    private let immomioLinkFetcher: ImmomioLinkFetcher
    
    init(immomioLinkFetcher: ImmomioLinkFetcher) {
        self.immomioLinkFetcher = immomioLinkFetcher
    }
    
    public func start(completion: @escaping ([Apartment]) -> ()) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        
        for landlord in landlords {
            dispatchGroup.enter()
            landlord.fetchApartmentsList { result in
                switch result {
                case .success(let apartments): currentApartments += apartments
                case .failure(let error): print("Failed to fetch apartments for landlord. Error: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.comparePreviousApartments(with: currentApartments) { newApartments in
                completion(newApartments)
            }
            self?.previousApartments = currentApartments
        }
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment], completion: @escaping ([Apartment]) -> ()) {
        let newApartments = findNewApartments(from: currentApartments)
        fetchImmomioLinks(for: newApartments) { modifiedApartments in
            completion(modifiedApartments)
        }
    }
    
    private func findNewApartments(from currentApartments: [Apartment]) -> [Apartment] {
        return currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.internalLink == apartment.internalLink })
        }
    }
    
    private func fetchImmomioLinks(for apartments: [Apartment], completion: @escaping ([Apartment]) -> ()) {
        let dispatchGroup = DispatchGroup()
        var modifiedApartments = [Apartment]()
        
        let sagaApartments = apartments.filter { $0.company == .saga }
        
        for apartment in sagaApartments {
            dispatchGroup.enter()
            immomioLinkFetcher.fetchLink(for: apartment.internalLink) { result in
                switch result {
                case .success(let immomioLink):
                    var sagaModifiedApartment = apartment
                    sagaModifiedApartment.externalLink = immomioLink
                    modifiedApartments.append(sagaModifiedApartment)
                case .failure(let error): print("Failed to fetch Immomio link for apartment: \(apartment.title). Error: \(error)")
                }
                dispatchGroup.leave()
            }
            
        }
        modifiedApartments += apartments.filter { $0.company != .saga }
        dispatchGroup.notify(queue: .main) {
            completion(modifiedApartments)
        }
    }
}
