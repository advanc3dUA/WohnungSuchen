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
    var optionsView: OptionsView!
    private let timerUpdateSubject = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: ModalVCDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = Colour.brandOlive.setColor
        setupStartStopButton()
        setupOptionsView()
        toggleSaveButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func toggleSaveButtonState() {
        let roomsPub = Publishers.CombineLatest(optionsView.roomsMinTextField.publisher(for: \.text).removeDuplicates(), optionsView.roomsMaxTextField.publisher(for: \.text).removeDuplicates())
        
        let areaPub = Publishers.CombineLatest(optionsView.areaMinTextField.publisher(for: \.text).removeDuplicates(), optionsView.areaMaxTextField.publisher(for: \.text).removeDuplicates())
        
        let rentPub = Publishers.CombineLatest(optionsView.rentMinTextField.publisher(for: \.text).removeDuplicates(), optionsView.rentMaxTextField.publisher(for: \.text).removeDuplicates())

        Publishers.CombineLatest4(roomsPub, areaPub, rentPub, timerUpdateSubject.removeDuplicates())
            .dropFirst()
            .scan(nil) { previous, current in
                guard let updateTimerCurrent = current.3, let updateTimerCurrentDouble = Double(updateTimerCurrent), updateTimerCurrentDouble < 30 else { return current }
                self.optionsView.timerUpdateTextField.text = "30.0"
                return nil
            }
            .compactMap { $0 }
            .sink { _ in
                self.saveButtonIsEnabled(true)
            }
            .store(in: &cancellables)

        optionsView.timerUpdateTextField.publisher(for: \.text)
            .removeDuplicates()
            .subscribe(timerUpdateSubject)
            .store(in: &cancellables)
    }
    
    private func saveButtonIsEnabled(_ param: Bool) {
        if param {
            optionsView.saveButton.alpha = 1.0
            optionsView.saveButton.isEnabled = true
        } else {
            optionsView.saveButton.alpha = 0.5
            optionsView.saveButton.isEnabled = false
        }
    }
    
    private func setupOptionsView() {
        let optionsNib = UINib(nibName: "OptionsView", bundle: nil)
        optionsView = optionsNib.instantiate(withOwner: self).first as? OptionsView
        optionsView.soundSwitch.set(offTint: Colour.brandGray.setColor)
        optionsView.soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
        saveButtonIsEnabled(false)
        optionsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        if let roomsMin = optionsView.roomsMinTextField.text,
           let roomsMax = optionsView.roomsMaxTextField.text,
           let areaMin = optionsView.areaMinTextField.text,
           let areaMax = optionsView.areaMaxTextField.text,
           let rentMin = optionsView.rentMinTextField.text,
           let rentMax = optionsView.rentMaxTextField.text,
           let updateTime = optionsView.timerUpdateTextField.text {
            UserDefaults.standard.set(Int(roomsMin), forKey: SavingKeys.roomsMin.rawValue)
            UserDefaults.standard.set(Int(roomsMax), forKey: SavingKeys.roomsMax.rawValue)
            UserDefaults.standard.set(Int(areaMin), forKey: SavingKeys.areaMin.rawValue)
            UserDefaults.standard.set(Int(areaMax), forKey: SavingKeys.areaMax.rawValue)
            UserDefaults.standard.set(Int(rentMin), forKey: SavingKeys.rentMin.rawValue)
            UserDefaults.standard.set(Int(rentMax), forKey: SavingKeys.rentMax.rawValue)
            UserDefaults.standard.set(TimeInterval(updateTime), forKey: SavingKeys.updateTime.rawValue)
            UserDefaults.standard.set(optionsView.soundSwitch.isOn, forKey: SavingKeys.soundIsOn.rawValue)
        }
        saveButtonIsEnabled(false)
    }
    
    @objc func soundSwitchChanged(_ sender: UISwitch) {
        delegate.setNotificationManagerAlertType(with: sender.isOn)
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

