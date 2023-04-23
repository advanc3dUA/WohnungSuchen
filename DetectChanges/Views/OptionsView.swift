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
        
        let roomsMin = String(UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int ?? Constants.defaultOptions.roomsMin)
        roomsMinTextField.attributedPlaceholder = NSAttributedString(string: roomsMin, attributes: defaultAttributes)
        roomsMinTextField.attributedText = NSAttributedString(string: roomsMin)
        
        let roomsMax = String(UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int ?? Constants.defaultOptions.roomsMax)
        roomsMaxTextField.attributedPlaceholder = NSAttributedString(string: roomsMax, attributes: defaultAttributes)
        roomsMaxTextField.attributedText = NSAttributedString(string: roomsMax)
        
        let areaMin = String(UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int ?? Constants.defaultOptions.areaMin)
        areaMinTextField.attributedPlaceholder = NSAttributedString(string: areaMin, attributes: defaultAttributes)
        areaMinTextField.attributedText = NSAttributedString(string: areaMin)
        
        let areaMax = String(UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int ?? Constants.defaultOptions.areaMax)
        areaMaxTextField.attributedPlaceholder = NSAttributedString(string: areaMax, attributes: defaultAttributes)
        areaMaxTextField.attributedText = NSAttributedString(string: areaMax)
        
        let rentMin = String(UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int ?? Constants.defaultOptions.rentMin)
        rentMinTextField.attributedPlaceholder = NSAttributedString(string: rentMin, attributes: defaultAttributes)
        rentMinTextField.attributedText = NSAttributedString(string: rentMin)
        
        let rentMax = String(UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int ?? Constants.defaultOptions.rentMax)
        rentMaxTextField.attributedPlaceholder = NSAttributedString(string: rentMax, attributes: defaultAttributes)
        rentMaxTextField.attributedText = NSAttributedString(string: rentMax)
        
        let updateTime = String(UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? TimeInterval ?? Constants.defaultOptions.updateTime)
        timerUpdateTextField.attributedPlaceholder = NSAttributedString(string: updateTime, attributes: defaultAttributes)
        timerUpdateTextField.attributedText = NSAttributedString(string: updateTime)
        
        let soundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool ?? Constants.defaultOptions.soundIsOn
        soundSwitch.isOn = soundIsOn
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
