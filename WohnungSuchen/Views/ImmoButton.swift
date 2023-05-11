//
//  ImmoButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.03.2023.
//

import UIKit

@IBDesignable
final class ImmoButton: CustomButton {
    
    override func setup() {
        super.setup()
        layer.borderColor = Colour.brandDark.setColor?.cgColor
        setTitle("🔗", for: .normal)
        
        let normalBackgroundColor = imageWithColor(Colour.brandBlue.setColor ?? .clear)
        setBackgroundImage(normalBackgroundColor, for: .normal)
        
        let highlightedBackgroundColor = imageWithColor(Colour.brandDark.setColor ?? .clear)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}
