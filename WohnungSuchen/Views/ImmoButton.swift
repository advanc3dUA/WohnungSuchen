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
        layer.borderColor = Color.brandDark.setColor?.cgColor
        setTitle("🔗", for: .normal)
        
        let normalBackgroundColor = imageWithColor(Color.brandBlue.setColor ?? .clear)
        setBackgroundImage(normalBackgroundColor, for: .normal)
        
        let highlightedBackgroundColor = imageWithColor(Color.brandDark.setColor ?? .clear)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}
