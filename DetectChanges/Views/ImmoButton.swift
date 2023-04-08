//
//  ImmoButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.03.2023.
//

import UIKit

@IBDesignable
class ImmoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = Colour.brandBlue.setColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = Colour.brandDark.setColor?.cgColor
        setTitle("🔗", for: .normal)
    }
}
