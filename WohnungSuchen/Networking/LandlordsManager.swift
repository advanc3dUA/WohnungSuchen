//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation

final class LandlordsManager {
    fileprivate var previousApartments: [Apartment]
    private let immomioLinkFetcher: ImmomioLinkFetcher
    private let selectedLandlords: [String: Bool]
    private var landlords: [Landlord]
    
    init(immomioLinkFetcher: ImmomioLinkFetcher, for selectedLandlords: [String: Bool]) {
        self.immomioLinkFetcher = immomioLinkFetcher
        self.selectedLandlords = selectedLandlords
        self.landlords = []
        self.previousApartments = []
    }
    
    private func getLandlordsList(with selectedLandlords: [String: Bool]) -> [Landlord] {
        var landlordsArray = [Landlord]()
        
        for (key, value) in selectedLandlords {
            if value {
                if key == "saga" {
                    let saga = Saga()
                    landlordsArray.append(saga)
                }
                
                if key == "vonovia" {
                    let vonovia = Vonovia()
                    landlordsArray.append(vonovia)
                }
            }
        }
        return landlordsArray
    }
    
    public func start(completion: @escaping ([Apartment]) -> ()) {
        landlords = getLandlordsList(with: selectedLandlords)
        
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
