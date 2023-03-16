//
//  ImmoButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.03.2023.
//

import UIKit

class ImmoButton: UIButton {
    var immomioLink = ""
    
    convenience init(for apartment: Apartment) {
        self.init(type: .system)
        backgroundColor = .white
        setTitleColor(.red, for: .normal)
        setTitle("Apartment \(apartment.index ?? -1)", for: .normal)
        self.immomioLink = apartment.immomioLink ?? "no link"
    }
}
