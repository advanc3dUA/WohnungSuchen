//
//  UIView + removeAllSubviews.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 16.03.2023.
//

import Foundation
import UIKit

extension UIView {
    func removeAllSubviews() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
