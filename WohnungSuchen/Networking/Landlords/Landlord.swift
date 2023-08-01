//
//  Landlord.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation

protocol Landlord {
    func fetchApartmentsList(completion: @escaping (Result<[Apartment], AppError>) -> Void)
}
