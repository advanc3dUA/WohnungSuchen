//
//  LandlordsManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation

final class LandlordsManager {
    var previousApartments: [Apartment]
    private let immomioLinkFetcher: ImmomioLinkFetcher
    var landlords: [Landlord]
    
    init(immomioLinkFetcher: ImmomioLinkFetcher) {
        self.immomioLinkFetcher = immomioLinkFetcher
        self.landlords = []
        self.previousApartments = []
    }
    
    public func start(completion: @escaping (Result<[Apartment], AppError>) -> ()) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        var errorOccured = false
        
        for landlord in landlords {
            dispatchGroup.enter()
            landlord.fetchApartmentsList { result in
                switch result {
                case .success(let apartments):
                    currentApartments += apartments
                case .failure(let error):
                    completion(.failure(error))
                    errorOccured = true
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            if errorOccured {
                return
            }
            self?.comparePreviousApartments(with: currentApartments) { result in
                switch result {
                case .success(let newApartments):
                    completion(.success(newApartments))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self?.previousApartments = currentApartments
        }
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment], completion: @escaping (Result<[Apartment], AppError>) -> ()) {
        let newApartments = findNewApartments(from: currentApartments)
        fetchImmomioLinks(for: newApartments) { result in
            switch result {
            case .success(let modifiledApartments):
                completion(.success(modifiledApartments))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func findNewApartments(from currentApartments: [Apartment]) -> [Apartment] {
        return currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.internalLink == apartment.internalLink })
        }
    }
    
    private func fetchImmomioLinks(for apartments: [Apartment], completion: @escaping (Result<[Apartment], AppError>) -> ()) {
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
                case .failure(let error):
                    completion(.failure(error))
                }
                dispatchGroup.leave()
            }
            
        }
        modifiedApartments += apartments.filter { $0.company != .saga }
        dispatchGroup.notify(queue: .main) {
            completion(.success(modifiedApartments))
        }
    }
}
