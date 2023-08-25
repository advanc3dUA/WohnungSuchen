//
//  ApartmentCell.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 03.04.2023.
//

import UIKit

final class ApartmentCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet var linkButton: ImmoButton!
    @IBOutlet weak var mapButton: MapButton!
    weak var delegate: ApartmentCellDelegate?
    var apartment: Apartment?

    class var identifier: String {
        String(describing: self)
    }

    class var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
