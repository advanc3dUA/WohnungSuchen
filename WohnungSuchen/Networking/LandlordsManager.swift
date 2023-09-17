//
//  LandlordsManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation

final class LandlordsManager {
    var previousApartments: [Apartment]
    var landlords: [Landlord]

    init() {
        self.landlords = []
        self.previousApartments = []
    }

    public func start(completion: @escaping (Result<[Apartment], AppError>) -> Void) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        var errorOccured = false

        landlords.forEach { landlord in
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

    private func comparePreviousApartments(with currentApartments: [Apartment], completion: @escaping (Result<[Apartment], AppError>) -> Void) {
        fetchExternalLinks(for: findNewApartments(from: currentApartments)) { result in
            switch result {
            case .success(let modifiedApartments):
                completion(.success(modifiedApartments))
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

    private func fetchExternalLinks(for apartments: [Apartment], completion: @escaping (Result<[Apartment], AppError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var modifiedApartments = [Apartment]()

        apartments.forEach { apartment in
            dispatchGroup.enter()
            let landlord = apartment.landlord
            landlord.setExternalLink(for: apartment) { result in
                switch result {
                case .success(let modifiedApartment):
                    modifiedApartments.append(modifiedApartment)
                case .failure(let error):
                    completion(.failure(error))
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(modifiedApartments))
        }
    }
}
