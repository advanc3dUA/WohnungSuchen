//
//  DetectDetent.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit

protocol DetectDetent {
    func detentChanged(detent: UISheetPresentationController.Detent.Identifier)
}
