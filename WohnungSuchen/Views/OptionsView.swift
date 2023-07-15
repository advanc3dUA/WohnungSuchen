//
//  OptionsView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import UIKit

final class OptionsView: UIView {
    
    @IBOutlet weak var roomsMinTextField: UITextField!
    @IBOutlet weak var roomsMaxTextField: UITextField!
    @IBOutlet weak var areaMinTextField: UITextField!
    @IBOutlet weak var areaMaxTextField: UITextField!
    @IBOutlet weak var rentMinTextField: UITextField!
    @IBOutlet weak var rentMaxTextField: UITextField!
    @IBOutlet weak var saveButton: SaveButton!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var timerUpdateTextField: UITextField!
    
    @IBOutlet weak var addSaga: UIButton!
    @IBOutlet weak var addVonovia: UIButton!
    @IBOutlet weak var removeVonovia: UIButton!
    @IBOutlet weak var removeSaga: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateOptionsUI(with options: Options) {
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        roomsMinTextField.attributedText = NSAttributedString(string: String(options.roomsMin), attributes: defaultAttributes)
        roomsMaxTextField.attributedText = NSAttributedString(string: String(options.roomsMax), attributes: defaultAttributes)
        areaMinTextField.attributedText = NSAttributedString(string: String(options.areaMin), attributes: defaultAttributes)
        areaMaxTextField.attributedText = NSAttributedString(string: String(options.areaMax), attributes: defaultAttributes)
        rentMinTextField.attributedText = NSAttributedString(string: String(options.rentMin), attributes: defaultAttributes)
        rentMaxTextField.attributedText = NSAttributedString(string: String(options.rentMax), attributes: defaultAttributes)
        timerUpdateTextField.attributedText = NSAttributedString(string: String(options.updateTime), attributes: defaultAttributes)
        soundSwitch.isOn = options.soundIsOn
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
