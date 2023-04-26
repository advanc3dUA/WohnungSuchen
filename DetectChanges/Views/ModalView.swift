//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit
import Combine

class ModalView: UIView {
    
    var containerView: UIView!
    var startPauseButton: StartPauseButton!
    var stopButton: StopButton!
    var delegate: ModalVCDelegate
    var options: Options
    var optionsView: OptionsView!
    private let timerUpdateSubject = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: ModalVCDelegate, options: Options) {
        self.delegate = delegate
        self.options = options
        super.init(frame: .zero)
        backgroundColor = Colour.brandOlive.setColor
        setupStartStopButton()
        setupOptionsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup views
    
    private func setupOptionsView() {
        let optionsNib = UINib(nibName: "OptionsView", bundle: nil)
        optionsView = optionsNib.instantiate(withOwner: self).first as? OptionsView
        optionsView.soundSwitch.set(offTint: Colour.brandGray.setColor)
        optionsView.soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
        optionsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButtonIsEnabled(false)
    }
    
    func showOptionsContent() {
        self.addSubview(optionsView)
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            optionsView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            optionsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            optionsView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -5),
            optionsView.topAnchor.constraint(equalTo: centerYAnchor, constant: -275)
        ])
    }
    
    func hideOptionsContent() {
        optionsView.removeFromSuperview()
    }
    
    private func setupStartStopButton() {
        let buttonsWidth = 75
        let buttonsHeight = 50
        let spacing = 5
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Colour.brandOlive.setColor
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth * 2 + spacing)),
            containerView.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
        
        startPauseButton = StartPauseButton()
        startPauseButton.addTarget(self, action: #selector(startPauseButtonTapped(sender:)), for: .touchUpInside)
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(startPauseButton)
        NSLayoutConstraint.activate([
            startPauseButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth)),
            startPauseButton.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            startPauseButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            startPauseButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        stopButton = StopButton()
        stopButton.addTarget(self, action: #selector(stopButtonTapped(sender:)), for: .touchUpInside)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth)),
            stopButton.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            stopButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            stopButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    func saveButtonIsEnabled(_ param: Bool) {
        if param {
            optionsView.saveButton.alpha = 1.0
            optionsView.saveButton.isEnabled = true
        } else {
            optionsView.saveButton.alpha = 0.5
            optionsView.saveButton.isEnabled = false
        }
    }
    
    @objc func saveButtonTapped() {
        UserDefaults.standard.set(options.roomsMin, forKey: SavingKeys.roomsMin.rawValue)
        UserDefaults.standard.set(options.roomsMax, forKey: SavingKeys.roomsMax.rawValue)
        UserDefaults.standard.set(options.areaMin, forKey: SavingKeys.areaMin.rawValue)
        UserDefaults.standard.set(options.areaMax, forKey: SavingKeys.areaMax.rawValue)
        UserDefaults.standard.set(options.rentMin, forKey: SavingKeys.rentMin.rawValue)
        UserDefaults.standard.set(options.rentMax, forKey: SavingKeys.rentMax.rawValue)
        UserDefaults.standard.set(options.updateTime, forKey: SavingKeys.updateTime.rawValue)
        UserDefaults.standard.set(options.soundIsOn, forKey: SavingKeys.soundIsOn.rawValue)
        saveButtonIsEnabled(false)
    }
    
    @objc func soundSwitchChanged(_ sender: UISwitch) {
        delegate.setNotificationManagerAlertType(with: sender.isOn)
    }
    
    @objc func startPauseButtonTapped(sender: StartPauseButton) {
        if sender.isOn {
            sender.switchOff()
            delegate.startEngine()
        } else {
            sender.switchOn()
            delegate.pauseEngine()
        }
    }
    
    @objc func stopButtonTapped(sender: StopButton) {
        delegate.stopEngine()
    }
    
}

