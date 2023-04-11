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
        print("erasing currentApartments (\(currentApartments.count)) in start method")
        let dispatchGroup = DispatchGroup()
        for landlord in landlords {
            dispatchGroup.enter()
            landlord.getApartmentsList { [unowned self] apartments in
                currentApartments += apartments.filter { apartment in
                    apartment.rooms >= options.rooms && apartment.area >= options.area && apartment.rent <= options.rent
                }
                print("Landlord: \(landlord.title). Number of apartments found: \(apartments.count)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            print("Initializing compparing of currentApartments (\(currentApartments.count)) and previousApartments (\(previousApartments.count))")
            print("First apartment in currentApartment immomioLink is: \(currentApartments.first?.externalLink)")
            let newApartments = comparePreviousApartments(with: currentApartments)
            print("saving currentApartments (\(currentApartments.count)) to previous")
            previousApartments = currentApartments
            print("sending to completion \(newApartments.count) apartments")
            print("-----------------------")
            completion(newApartments)
        }
    }
    
    private func comparePreviousApartments(with currentApartments: [Apartment]) -> [Apartment] {
        return currentApartments.filter { apartment in
            !previousApartments.contains(where: { $0.externalLink == apartment.externalLink })
        }
    }
    
    func setOptions(_ options: Options) {
        self.options = options
    }
}
