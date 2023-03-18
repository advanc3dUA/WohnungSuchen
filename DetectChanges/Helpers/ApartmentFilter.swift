//
//  ApartmentFilter.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 18.03.2023.
//

import Foundation

struct ApartmentFilter {
    static let shared = ApartmentFilter(filter: Apartment(rooms: 2))
    let filterModel: Apartment
    private init(filter: Apartment) {
        self.filterModel = filter
    }
}
