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
    @IBOutlet weak var saveButton: SaveButton!
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
        
        roomsMinTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.roomsMin), attributes: defaultAttributes)
        roomsMinTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.roomsMin))
        
        roomsMaxTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.roomsMax), attributes: defaultAttributes)
        roomsMaxTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.roomsMax))
        
        areaMinTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.areaMin), attributes: defaultAttributes)
        areaMinTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.areaMin))
        
        areaMaxTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.areaMax), attributes: defaultAttributes)
        areaMaxTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.areaMax))
        
        rentMinTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rentMin), attributes: defaultAttributes)
        rentMinTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.rentMin))
        
        rentMaxTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.rentMax), attributes: defaultAttributes)
        rentMaxTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.rentMax))
        
        timerUpdateTextField.attributedPlaceholder = NSAttributedString(string: String(Constants.defaultOptions.updateTime), attributes: defaultAttributes)
        timerUpdateTextField.attributedText = NSAttributedString(string: String(Constants.defaultOptions.updateTime))
        
        soundSwitch.isOn = Constants.defaultOptions.soundIsOn
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
