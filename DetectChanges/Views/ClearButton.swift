//
//  ClearButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 08.04.2023.
//

import UIKit

class ClearButton: UIButton {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Colour.brandDark.setColor?.cgColor
        backgroundColor = Colour.brandBlue.setColor
        setTitle("Clear", for: .normal)
        setTitleColor(Colour.brandDark.setColor, for: .normal)
    }
}
