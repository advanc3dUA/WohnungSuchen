//
//  MapButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import UIKit

@IBDesignable
final class MapButton: CustomButton {
    
    override func setup() {
        super.setup()
        layer.borderColor = Colour.brandBlue.setColor?.cgColor
        setTitle("🧭", for: .normal)
        
        let normalBackgroundColor = imageWithColor(Colour.brandDark.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(normalBackgroundColor, for: .normal)
        
        let highlightedBackgroundColor = imageWithColor(Colour.brandBlue.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}
