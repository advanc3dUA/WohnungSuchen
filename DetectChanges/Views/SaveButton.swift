//
//  SaveButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 23.04.2023.
//

import Foundation

@IBDesignable
final class SaveButton: CustomButton {
    override func setup() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        clipsToBounds = true
        layer.borderColor = Colour.brandDark.setColor?.cgColor
        backgroundColor = Colour.brandBlue.setColor
        
        // Set title and title colors for both the normal and highlighted states
        setTitle("Save", for: .normal)
        setTitleColor(.white, for: .normal)
        setTitle("Save", for: .highlighted)
        setTitleColor(.white, for: .highlighted)
        
        // Set background images for both the normal and highlighted states
        let normalBackgroundColor = imageWithColor(Colour.brandBlue.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(normalBackgroundColor, for: .normal)
        
        let highlightedBackgroundColor = imageWithColor(Colour.brandDark.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}

