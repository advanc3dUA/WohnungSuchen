//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation
import SwiftSoup

class LandlordsManager {
    private var previousApartments = [Apartment]()
    var landlords: [Landlord] = [Saga()]
    
    public func start(completion: @escaping ([Apartment]) -> ()) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        
        for landlord in landlords {
            dispatchGroup.enter()
            landlord.getApartmentsList { apartments in
                currentApartments += apartments.filter({ apartment in
                    apartment.rooms >= ApartmentFilter.shared.filterModel.rooms
                })
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            let newApartments = comparePreviousApartments(with: currentApartments)
            previousApartments = currentApartments
            
            let indexedApartments = newApartments.enumerated().map { (index, apartment) in
                var indexedApartment = apartment
                indexedApartment.index = index
                return indexedApartment
            }
            completion(indexedApartments)
        }
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment]) -> [Apartment] {
        return currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.link == apartment.link })
        }
    }
}
