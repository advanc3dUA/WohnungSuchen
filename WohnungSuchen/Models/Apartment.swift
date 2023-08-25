//
//  Apartment.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 11.03.2023.
//

import Foundation

struct Apartment {
    let time: String
    let title: String
    let internalLink: String
    let street: String
    let rooms: Int
    let area: Int
    let rent: Int
    let externalLink: String
    let company: Company
    var isNew: Bool

    init(time: String,
         title: String,
         internalLink: String,
         street: String,
         rooms: Int,
         area: Int,
         rent: Int,
         externalLink: String = "",
         company: Company,
         isNew: Bool = false) {

        self.time = time
        self.title = title
        self.internalLink = internalLink
        self.street = street
        self.rooms = rooms
        self.area = area
        self.rent = rent
        self.externalLink = externalLink
        self.company = company
        self.isNew = isNew
    }

    // This init creates copy of Apartment with new externalLink
    init(apartment: Apartment, with externalLink: String) {
        self.time = apartment.time
        self.title = apartment.title
        self.internalLink = apartment.internalLink
        self.street = apartment.street
        self.rooms = apartment.rooms
        self.area = apartment.area
        self.rent = apartment.rent
        self.externalLink = externalLink
        self.company = apartment.company
        self.isNew = apartment.isNew
    }
}
