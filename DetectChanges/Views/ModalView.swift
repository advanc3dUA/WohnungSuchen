//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ModalView: UIView {
    
    var buttonsContainerView: ButtonsContainerView!
    var startStopButton: StartStopButton!
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .darkGray
        setupButtonsContainerView()
        setupStartStopButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonsContainerView() {
        buttonsContainerView = ButtonsContainerView(self.frame.width)
        addSubview(buttonsContainerView)
        
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: (Constants.buttonHeight + Constants.spacing) * CGFloat(Constants.maxRows) - Constants.spacing)
         ])
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

