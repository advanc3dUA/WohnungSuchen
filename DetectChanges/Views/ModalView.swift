//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ModalView: UIView {
    
    var containerView: UIView!
    var startPauseButton: StartPauseButton!
    var stopButton: StopButton!
    var delegate: ModalVCDelegate
    var optionsView: OptionsView!
    
    init(delegate: ModalVCDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = Colour.brandOlive.setColor
        setupStartStopButton()
        setupOptionsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupOptionsView() {
        let optionsNib = UINib(nibName: "OptionsView", bundle: nil)
        optionsView = optionsNib.instantiate(withOwner: self).first as? OptionsView
        optionsView.soundSwitch.set(offTint: Colour.brandGray.setColor)
        optionsView.soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
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
            optionsView.topAnchor.constraint(equalTo: centerYAnchor, constant: -100)
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

