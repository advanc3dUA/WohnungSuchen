//
//  ProvidersCollectionViewCell.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 16.07.2023.
//

import UIKit

final class ProvidersCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var providerButton: SaveButton!

    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    func configure(title: String, isSelected: Bool) {
        providerButton.setTitle(title, for: .normal)
        providerButton.setTitle(title, for: .highlighted)
        providerButton.isSelected = isSelected
    }

    func setProviderButtonTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        providerButton.addTarget(target, action: action, for: event)
    }
}
