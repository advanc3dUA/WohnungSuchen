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
        backgroundColor = UIColor(named: "BrandBlue")
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "BrandDark")?.cgColor
        setTitle("🔗", for: .normal)
    }
}
