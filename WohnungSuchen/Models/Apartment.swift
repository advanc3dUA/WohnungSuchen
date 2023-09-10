//
//  Apartment.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 11.03.2023.
//

import UIKit

struct Apartment {
    let time: String
    let title: String
    let internalLink: String
    let street: String
    let rooms: Int
    let area: Int
    let rent: Int
    let externalLink: String
    let logoImage: UIImage?
    let landlord: Landlord
    var isNew: Bool

    init(time: String,
         title: String,
         internalLink: String,
         street: String,
         rooms: Int,
         area: Int,
         rent: Int,
         externalLink: String = "",
         imageLink: String = "",
         landlord: Landlord,
         isNew: Bool = false) {

        self.time = time
        self.title = title
        self.internalLink = internalLink
        self.street = street
        self.rooms = rooms
        self.area = area
        self.rent = rent
        self.externalLink = externalLink
        self.logoImage = UIImage(named: imageLink)
        self.landlord = landlord
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
        self.logoImage = apartment.logoImage
        self.landlord = apartment.landlord
        self.isNew = apartment.isNew
    }
}
