//
//  VonoviaJson.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 02.04.2023.
//

import Foundation

struct VonoviaJson: Decodable {
    var apartments: [VonoviaApartment]
    
    private enum CodingKeys: String, CodingKey {
        case apartments = "results"
    }
}

extension VonoviaJson {
    struct VonoviaApartment: Decodable {
        let wrk_id: String
        let strasse: String
        let titel: String
        let preis: String
        let groesse: String
        let anzahl_zimmer: String
        let slug: String
    }
}

