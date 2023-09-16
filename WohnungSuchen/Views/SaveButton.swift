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
        super.setup()
        layer.borderColor = Color.brandDark.setColor?.cgColor

        // Set title and title colors for both the normal and highlighted states
        setTitle("Save", for: .normal)
        setTitleColor(.white, for: .normal)
        setTitle("Save", for: .highlighted)
        setTitleColor(.white, for: .highlighted)

        // Set background images for both the normal and highlighted states
        let normalBackgroundColor = imageWithColor(Color.brandBlue.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(normalBackgroundColor, for: .normal)

        let highlightedBackgroundColor = imageWithColor(Color.brandDark.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }

    func toggleState(with state: Bool) {
        if state {
            self.alpha = 1.0
            self.isEnabled = true
        } else {
            self.alpha = 0.5
            self.isEnabled = false
        }
    }
}
