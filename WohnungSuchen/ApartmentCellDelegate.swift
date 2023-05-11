//
//  ApartmentCellDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 05.04.2023.
//

import Foundation

protocol ApartmentCellDelegate: AnyObject {
    func didTapLinkButtonInCell(with apartmentLink: String)
    func didTapMapButtonInCell(with address: String)
}
