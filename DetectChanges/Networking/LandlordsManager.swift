//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import Foundation
import SwiftSoup

class LandlordsManager {
    private var options: Options
    private var previousApartments = [Apartment]()
    var landlords: [Landlord] = [Saga(), Vonovia()]
    
    init(with options: Options) {
        self.options = options
    }
    
    public func start(completion: @escaping ([Apartment]) -> ()) {
        var currentApartments = [Apartment]()
        let dispatchGroup = DispatchGroup()
        for landlord in landlords {
            dispatchGroup.enter()
            landlord.getApartmentsList { [unowned self] apartments in
                currentApartments += apartments.filter { apartment in
                    apartment.rooms >= options.rooms && apartment.area >= options.area && apartment.rent <= options.rent
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            let newApartments = comparePreviousApartments(with: currentApartments)
            previousApartments = currentApartments

            completion(newApartments)
        }
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment]) -> [Apartment] {
        return currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.link == apartment.link })
        }
    }
    
    func setOptions(_ options: Options) {
        self.options = options
    }
}
