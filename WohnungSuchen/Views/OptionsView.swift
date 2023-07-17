//
//  OptionsView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import UIKit
import Combine

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
    var providersCollectionView: UICollectionView!
    var optionsSubject: CurrentValueSubject<Options, Never>?
    
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
    
    func setLandlordsOption(with optionsSubject: CurrentValueSubject<Options, Never>) {
        self.optionsSubject = optionsSubject
    }
    
    func setupProvidersCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 30)

        providersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        providersCollectionView.register(ProvidersCollectionViewCell.nib, forCellWithReuseIdentifier: ProvidersCollectionViewCell.identifier)
        providersCollectionView.backgroundColor = Colour.brandGray.setColor
        
        providersCollectionView.delegate = self
        providersCollectionView.dataSource = self

        providersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(providersCollectionView)
        
        NSLayoutConstraint.activate([
            providersCollectionView.heightAnchor.constraint(equalToConstant: 30),
            providersCollectionView.widthAnchor.constraint(equalToConstant: 140),
            providersCollectionView.topAnchor.constraint(equalTo: self.saveButton.bottomAnchor, constant: 25),
            providersCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
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
