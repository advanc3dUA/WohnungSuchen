//
//  VonoviaJson.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 02.04.2023.
//

import Foundation

struct VonoviaJson: Codable {
    var apartments: [VonoviaApartment]
    
    private enum CodingKeys: String, CodingKey {
        case apartments = "results"
    }
}

struct VonoviaApartment: Codable {
    var wrk_id: String
    var strasse: String
    var titel: String
    var preis: String
    var groesse: String
    var anzahl_zimmer: String
    var slug: String
}


