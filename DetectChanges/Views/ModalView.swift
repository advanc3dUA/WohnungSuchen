//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ModalView: UIView {
    
    var startStopButton: StartStopButton!
    var delegate: ModalVCDelegate
    
    init(delegate: ModalVCDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = Colour.brandOlive.setColor
        setupStartStopButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStartStopButton() {
        startStopButton = StartStopButton()
        startStopButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startStopButton)
        NSLayoutConstraint.activate([
            startStopButton.widthAnchor.constraint(equalToConstant: 70),
            startStopButton.heightAnchor.constraint(equalToConstant: 70),
            startStopButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startStopButton.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
    
    @objc func startStopButtonTapped() {
        if startStopButton.isOn {
            startStopButton.switchOff()
            delegate.startEngine()
        } else {
            startStopButton.switchOn()
            delegate.stopEngine()
        }
    }

}

