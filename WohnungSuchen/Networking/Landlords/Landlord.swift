//
//  Landlord.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation

protocol Landlord {
    var name: String { get }
    func fetchApartmentsList(completion: @escaping (Result<[Apartment], AppError>) -> Void)
    func setExternalLink(for apartment: Apartment, completion: @escaping (Result<Apartment, AppError>) -> Void)
}
