//
//  VC+TableViewDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 05.04.2023.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apartmentsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApartmentCell.identifier, for: indexPath) as! ApartmentCell
        let apartment = apartmentsDataSource[indexPath.row]
        cell.apartment = apartment
        cell.delegate = self
        cell.selectionStyle = .none
        cell.addressLabel.text = "\(apartment.street)"
        cell.detailsLabel.text = "Rooms: \(apartment.rooms), m2: \(apartment.area), €: \(apartment.rent)"
        cell.logoImageView.image = apartment.company.logoImage
        cell.timeLabel.text = apartment.time
        cell.timeLabel.backgroundColor = apartment.isNew ? Colour.brandOlive.setColor : Colour.brandGray.setColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ApartmentCell else { return }
        if apartmentsDataSource[indexPath.row].isNew {
            cell.timeLabel.backgroundColor = Colour.brandGray.setColor
            apartmentsDataSource[indexPath.row].isNew = false
            if let index = currentApartments.firstIndex(where: { apartment in
                apartment.externalLink == apartmentsDataSource[indexPath.row].externalLink
            }) {
                currentApartments[index].isNew = false
            }
        } else {
            cell.timeLabel.backgroundColor = Colour.brandOlive.setColor
            apartmentsDataSource[indexPath.row].isNew = true
            if let index = currentApartments.firstIndex(where: { apartment in
                apartment.externalLink == apartmentsDataSource[indexPath.row].externalLink
            }) {
                currentApartments[index].isNew = true
            }
        }
    }
}
