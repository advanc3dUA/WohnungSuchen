//
//  VC+ApartmentCellDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 05.04.2023.
//

import UIKit

extension ViewController: ApartmentCellDelegate {
    func didTapLinkButtonInCell(with apartmentLink: String) {
        guard let url = URL(string: apartmentLink) else { return }
        UIApplication.shared.open(url)
    }
    
    func didTapMapButtonInCell(with address: String) {
        guard let address = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = "comgooglemaps://?q=\(address)&zoom=10"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

}
