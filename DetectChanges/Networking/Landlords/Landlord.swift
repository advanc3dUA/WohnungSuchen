//
//  Landlord.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation

protocol Landlord {
    var title: String { get }
    func getApartmentsList(completion: @escaping ([Apartment]) -> Void)
}
