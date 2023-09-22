//
//  SaveButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 23.04.2023.
//

import UIKit

@IBDesignable
final class SaveButton: CustomButton {

    override func setup() {
        super.setup()
        configure()
        updateAppearance()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAppearance()
    }

    private func configure() {
        layer.borderColor = Color.brandDark.setColor?.cgColor

        setTitle("Save", for: .normal)
        setTitleColor(Color.brandGray.setColor, for: .normal)
        setTitleColor(Color.brandGray.setColor, for: .selected)
    }

    private func updateAppearance() {
        let normalBackgroundColor = imageWithColor(Color.brandDark.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(normalBackgroundColor, for: .normal)

        let selectedbackgroundColor = imageWithColor(Color.brandBlue.setColor ?? .clear, cornerRadius: layer.cornerRadius)
        setBackgroundImage(selectedbackgroundColor, for: .selected)
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
