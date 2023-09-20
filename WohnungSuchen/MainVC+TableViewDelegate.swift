//
//  MainVC+TableViewDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 05.04.2023.
//

import UIKit

extension MainVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ApartmentCell.identifier, for: indexPath) as? ApartmentCell else {
            return UITableViewCell()
        }
        cell.configure(apartment: apartmentsDataSource[indexPath.row], delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ApartmentCell else { return }
        toggleIsNew(at: indexPath.row, cell: cell)
    }

    func toggleIsNew(at index: Int, cell: ApartmentCell) {
        let currentApartmentIndex = currentApartments.firstIndex { $0.externalLink == apartmentsDataSource[index].externalLink }

        let isNew = !apartmentsDataSource[index].isNew
        apartmentsDataSource[index].isNew = isNew
        cell.toggleTimeLabelColor(with: isNew)

        if let index = currentApartmentIndex {
            currentApartments[index].isNew = isNew
        }
    }
}
