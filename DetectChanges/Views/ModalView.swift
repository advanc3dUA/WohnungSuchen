//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ModalView: UIView {
    
    var containerView: UIView!
    var startStopButton: StartStopButton!
    var clearButton: ClearButton!
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
        
        startStopButton = StartStopButton()
        startStopButton.addTarget(self, action: #selector(startStopButtonTapped(sender:)), for: .touchUpInside)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(startStopButton)
        NSLayoutConstraint.activate([
            startStopButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth)),
            startStopButton.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            startStopButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            startStopButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        clearButton = ClearButton()
        clearButton.addTarget(self, action: #selector(clearButtonTapped(sender:)), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth)),
            clearButton.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            clearButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            clearButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    @objc func startStopButtonTapped(sender: StartStopButton) {
        if sender.isOn {
            sender.switchOff()
            delegate.startEngine()
        } else {
            sender.switchOn()
            delegate.stopEngine()
        }
    }
    
    @objc func clearButtonTapped(sender: ClearButton) {
        delegate.clearTableView()
    }

}

