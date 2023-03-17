//
//  MapButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import UIKit

class MapButton: UIButton {
    var street = ""
    
    convenience init(for apartment: Apartment) {
        self.init(type: .system)
        backgroundColor = .black
        setTitleColor(.systemGreen, for: .normal)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGreen.cgColor
        setTitle("🧭", for: .normal)
        self.street = apartment.street
    }
}
