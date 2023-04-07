//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ModalView: UIView {
    
//    var buttonsContainerView: ButtonsContainerView!
    var startStopButton: StartStopButton!
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "BrandOlive")
//        setupStartStopButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStartStopButton() {
        startStopButton = StartStopButton()
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startStopButton)
        NSLayoutConstraint.activate([
            startStopButton.widthAnchor.constraint(equalToConstant: 70),
            startStopButton.heightAnchor.constraint(equalToConstant: 70),
            startStopButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startStopButton.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
}

