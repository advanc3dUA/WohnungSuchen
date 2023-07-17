//
//  ProvidersCollectionViewCell.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 16.07.2023.
//

import UIKit

class ProvidersCollectionViewCell: UICollectionViewCell {

    @IBOutlet var providerButton: SaveButton!
    
    class var identifier: String {
        String(describing: self)
    }
    
    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        providerButton.layer.borderColor = Colour.brandDark.setColor?.cgColor
        let normalbackgroundColor = providerButton.imageWithColor(Colour.brandDark.setColor ?? .clear)
        providerButton.setBackgroundImage(normalbackgroundColor, for: .normal)
        
        let selectedbackgroundColor = providerButton.imageWithColor(Colour.brandBlue.setColor ?? .clear)
        providerButton.setBackgroundImage(selectedbackgroundColor, for: .selected)
    }
}
