//
//  Landlord.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation

protocol Landlord {
    func getApartmentsList(completion: @escaping ([Apartment]) -> Void)
}
