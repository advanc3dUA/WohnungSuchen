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
        configure()
        updateAppearance()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateAppearance()
    }

    private func configure() {
        layer.borderColor = Color.brandDark.setColor?.cgColor
        setTitle("🔗", for: .normal)
    }

    private func updateAppearance() {
        let normalBackgroundColor = imageWithColor(Color.brandBlue.setColor ?? .clear)
        setBackgroundImage(normalBackgroundColor, for: .normal)

        let highlightedBackgroundColor = imageWithColor(Color.brandDark.setColor ?? .clear)
        setBackgroundImage(highlightedBackgroundColor, for: .highlighted)
    }
}
