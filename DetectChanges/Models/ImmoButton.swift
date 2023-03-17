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
        backgroundColor = .systemGreen
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 5
        setTitle("#\(apartment.index)", for: .normal)
        self.immomioLink = apartment.immomioLink
    }
}
