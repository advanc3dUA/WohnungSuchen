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
        layer.borderColor = Color.brandBlue.setColor?.cgColor
        setTitle("🧭", for: .normal)
        
        let normalBackgroundColor = imageWithColor(Color.brandDark.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(normalBackgroundColor, for: .normal)
        
        let highlightedBackgroundColor = imageWithColor(Color.brandBlue.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}
