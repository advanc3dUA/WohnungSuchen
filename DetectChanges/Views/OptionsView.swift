//
//  OptionsView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import UIKit

class OptionsView: UIView {
    
    @IBOutlet weak var roomsMinTextField: UITextField!
    @IBOutlet weak var roomsMaxTextField: UITextField!
    @IBOutlet weak var areaMinTextField: UITextField!
    @IBOutlet weak var areaMaxTextField: UITextField!
    @IBOutlet weak var rentMinTextField: UITextField!
    @IBOutlet weak var rentMaxTextField: UITextField!
    
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
        roomsMinTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rooms.min), attributes: defaultAttributes)
        roomsMaxTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rooms.max), attributes: defaultAttributes)
        rentMinTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rent.min), attributes: defaultAttributes)
        rentMaxTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rent.max), attributes: defaultAttributes)
        areaMinTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.area.min), attributes: defaultAttributes)
        areaMaxTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.area.max), attributes: defaultAttributes)
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
