//
//  UISwitch+offTint.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 17.09.2023.
//

import UIKit

extension UISwitch {

    func set(offTint color: UIColor?) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
}
