//
//  MapButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import UIKit

@IBDesignable
class MapButton: CustomButton {
    
    override func setup() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = Colour.brandBlue.setColor?.cgColor
        setTitle("🧭", for: .normal)
        
        let normalBackgroundColor = imageWithColor(Colour.brandDark.setColor ?? .clear)
        setBackgroundImage(normalBackgroundColor, for: .normal)
        
        let highlightedBackgroundColor = imageWithColor(Colour.brandBlue.setColor ?? .clear)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}
