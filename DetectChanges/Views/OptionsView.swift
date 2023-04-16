//
//  OptionsView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import UIKit

class OptionsView: UIView {
    
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var timerUpdateTextField: UITextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roomsTextField.placeholder = String(Constants.defaultOptions.rooms)
        rentTextField.placeholder = String(Constants.defaultOptions.rent)
        areaTextField.placeholder = String(Constants.defaultOptions.area)
        timerUpdateTextField.placeholder = String(Constants.defaultOptions.updateTimer)
    }
}

extension UISwitch {

    func set(offTint color: UIColor?) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
}
