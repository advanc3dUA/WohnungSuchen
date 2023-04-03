//
//  ApartmentCell.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 03.04.2023.
//

import UIKit

class ApartmentCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var linkButton: ImmoButton!
    @IBOutlet weak var mapButton: MapButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
