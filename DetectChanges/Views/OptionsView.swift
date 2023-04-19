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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        roomsTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rooms), attributes: defaultAttributes)
        rentTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rent), attributes: defaultAttributes)
        areaTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.area), attributes: defaultAttributes)
        timerUpdateTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.updateTimer), attributes: defaultAttributes)
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
