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
        toggleSaveButtonState()
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
    
    //MARK: - Save button
    
    private func toggleSaveButtonState() {
        let roomsMinTextFieldPublisher = optionsView.roomsMinTextField.publisher(for: \.text)
        let roomsMaxTextFieldPublisher = optionsView.roomsMaxTextField.publisher(for: \.text)
        let areaMinTextFieldPublisher = optionsView.areaMinTextField.publisher(for: \.text)
        let areaMaxTextFieldPublisher = optionsView.areaMaxTextField.publisher(for: \.text)
        let rentMinTextFieldPublisher = optionsView.rentMinTextField.publisher(for: \.text)
        let rentMaxTextFieldPublisher = optionsView.rentMaxTextField.publisher(for: \.text)
        let timerUpdateTextFieldPublisher = optionsView.timerUpdateTextField.publisher(for: \.text)
            .print()
        
        
        let roomsMinIntPublisher = roomsMinTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.roomsMin)
            }
        let roomsMaxIntPublisher = roomsMaxTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.roomsMax)
            }
        
        let areaMinIntPublisher = areaMinTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.areaMin)
            }
        let areaMaxIntPublisher = areaMaxTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.areaMax)
            }
        
        let rentMinIntPublisher = rentMinTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.rentMin)
            }
        let rentMaxIntPublisher = rentMaxTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.rentMax)
            }
        
        let timerUpdateIntPublisher = timerUpdateTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.rentMax)
            }
        
        let roomsPub = Publishers.CombineLatest(roomsMinIntPublisher, roomsMaxIntPublisher)
        let areaPub = Publishers.CombineLatest(areaMinIntPublisher, areaMaxIntPublisher)
        let rentPub = Publishers.CombineLatest(rentMinIntPublisher, rentMaxIntPublisher)
        
        Publishers.CombineLatest4(roomsPub, areaPub, rentPub, timerUpdateIntPublisher)
            .dropFirst()
            .map { [unowned self] rooms, area, rent, updateTime in
                print("preparing to save options...")
                options.roomsMin = rooms.0
                options.roomsMax = rooms.1
                options.areaMin = area.0
                options.areaMax = area.1
                options.rentMin = rent.0
                options.rentMax = rent.1
                options.updateTime = updateTime
                print("saved!")
                print("options = \(options.roomsMin), \(options.roomsMax), \(options.areaMin), \(options.areaMax), \(options.rentMin), \(options.rentMax), \(options.updateTime)")
                
                return rooms.0 <= rooms.1 && area.0 <= area.1 && rent.0 <= rent.0
//                && updateTime >= 30
            }
            .sink { [unowned self] isValid in
                saveButtonIsEnabled(isValid)
            }
            .store(in: &cancellables)
//
//
//        let roomsPub = Publishers.CombineLatest(optionsView.roomsMinTextField.publisher(for: \.text).removeDuplicates(), optionsView.roomsMaxTextField.publisher(for: \.text).removeDuplicates())
//
//        let areaPub = Publishers.CombineLatest(optionsView.areaMinTextField.publisher(for: \.text).removeDuplicates(), optionsView.areaMaxTextField.publisher(for: \.text).removeDuplicates())
//
//        let rentPub = Publishers.CombineLatest(optionsView.rentMinTextField.publisher(for: \.text).removeDuplicates(), optionsView.rentMaxTextField.publisher(for: \.text).removeDuplicates())
//
//        Publishers.CombineLatest4(roomsPub, areaPub, rentPub, timerUpdateSubject.removeDuplicates())
//            .dropFirst()
//            .scan(nil) { previous, current in
//                guard let updateTimerCurrent = current.3, let updateTimerCurrentDouble = Double(updateTimerCurrent), updateTimerCurrentDouble < 30 else { return current }
//                self.optionsView.timerUpdateTextField.text = "30"
//                return nil
//            }
//            .compactMap { $0 }
//            .sink { _ in
//                self.saveButtonIsEnabled(true)
//            }
//            .store(in: &cancellables)
//
//        optionsView.timerUpdateTextField.publisher(for: \.text)
//            .removeDuplicates()
//            .subscribe(timerUpdateSubject)
//            .store(in: &cancellables)
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

