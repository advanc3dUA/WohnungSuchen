//
//  Constants.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import Foundation

struct Constants {
    static var apartButtonsWidth: CGFloat!
    static var immoButtonWidth: CGFloat! {
        didSet {
            mapButtonsWidth = (apartButtonsWidth - apartSpacing) - immoButtonWidth
        }
    }
    static var mapButtonsWidth: CGFloat!
    static var immoButtonPercentage: Double = 0.65
    
    static let buttonHeight: CGFloat = 44
    static let spacing: CGFloat = 8
    static let apartSpacing: CGFloat = 4
    static let maxButtonsPerRow = 3
    static let maxRows = 3
}
