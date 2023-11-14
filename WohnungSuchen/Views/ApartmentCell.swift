//
//  ApartmentCell.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 03.04.2023.
//

import UIKit

final class ApartmentCell: UITableViewCell {

    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var detailsLabel: UILabel!
    @IBOutlet private var linkButton: ImmoButton!
    @IBOutlet weak private var mapButton: MapButton!
    weak private var delegate: ApartmentCellDelegate?
    private var apartment: Apartment?

    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    func configure(apartment: Apartment, delegate: ApartmentCellDelegate?) {
        self.apartment = apartment
        self.delegate = delegate
        self.selectionStyle = .none
        addressLabel.text = "\(apartment.street)"
        detailsLabel.text = "Rooms: \(apartment.rooms), m²: \(apartment.area), €: \(apartment.rent)"
        logoImageView.image = apartment.logoImage
        timeLabel.text = apartment.time
        timeLabel.backgroundColor = apartment.isNew ? Color.brandContrast.setColor : Color.brandGray.setColor
    }

    func toggleTimeLabelColor(with state: Bool) {
        timeLabel.backgroundColor = state ? Color.brandContrast.setColor : Color.brandGray.setColor

    }

    @IBAction func linkButtonTapped(_ sender: ImmoButton) {
        guard let apartment = apartment else { return }
        delegate?.didTapLinkButtonInCell(with: apartment.externalLink)
    }

    @IBAction func mapButtonTapped(_ sender: MapButton) {
        guard let apartment = apartment else { return }
        delegate?.didTapMapButtonInCell(with: apartment.street)
    }
}
