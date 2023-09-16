//
//  ProvidersCollectionViewCell.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 16.07.2023.
//

import UIKit

final class ProvidersCollectionViewCell: UICollectionViewCell {

    @IBOutlet var providerButton: SaveButton!

    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        providerButton.layer.borderColor = Color.brandDark.setColor?.cgColor
        let normalbackgroundColor = providerButton.imageWithColor(Color.brandDark.setColor ?? .clear)
        providerButton.setBackgroundImage(normalbackgroundColor, for: .normal)
        providerButton.setTitleColor(.white, for: .normal)

        let selectedbackgroundColor = providerButton.imageWithColor(Color.brandBlue.setColor ?? .clear)
        providerButton.setBackgroundImage(selectedbackgroundColor, for: .selected)
        providerButton.setTitleColor(.white, for: .selected)
    }
}
