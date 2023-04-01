//
//  ButtonsContainerView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ButtonsContainerView: UIView {
    var modalView: ModalView

    init(for modalView: ModalView) {
        self.modalView = modalView
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        frame = CGRect(x: 0,
                       y: 0,
                       width: modalView.frame.width,
                       height: CGFloat(Constants.maxRows) * (Constants.buttonHeight + Constants.spacing)
        )
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: modalView.topAnchor, constant: 10),
//            leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 10),
//            trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -10),
//            heightAnchor.constraint(equalToConstant: (Constants.buttonHeight + Constants.spacing) * CGFloat(Constants.maxRows) - Constants.spacing)
//         ])
    }

    func showButtons(for apartments: [Apartment]) {
        var index = 0
        for apartment in apartments {
            guard index < Constants.maxRows * Constants.maxButtonsPerRow else { return }
            let immoButton = ImmoButton(for: apartment)
            immoButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing),
                                      y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
                                      width: Constants.immoButtonWidth,
                                      height: Constants.buttonHeight)

            let mapButton = MapButton(for: apartment)
            mapButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing) + Constants.immoButtonWidth + Constants.apartSpacing,
                                     y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
                                     width: Constants.mapButtonsWidth,
                                     height: Constants.buttonHeight)

            index += 1
            self.addSubview(immoButton)
            self.addSubview(mapButton)
        }
    }
    
//    private func setupStartStopButton() {
//        let startStopButton = StartStopButton()
//        startStopButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(startStopButton)
//        NSLayoutConstraint.activate([
//            startStopButton.widthAnchor.constraint(equalToConstant: 70),
//            startStopButton.heightAnchor.constraint(equalToConstant: 70),
//            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            startStopButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
//        ])
//    }
}
