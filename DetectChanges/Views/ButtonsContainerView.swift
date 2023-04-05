//
//  ButtonsContainerView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ButtonsContainerView: UIView {
    var superViewWidth: CGFloat

    init(_ superViewWidth: CGFloat) {
        self.superViewWidth = superViewWidth
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        frame = CGRect(x: 0,
                       y: 0,
                       width: superViewWidth,
                       height: CGFloat(Constants.maxRows) * (Constants.buttonHeight + Constants.spacing)
        )
        backgroundColor = .clear
    }

//    func showButtons(for apartments: [Apartment]) {
//        var index = 0
//        for apartment in apartments {
//            guard index < Constants.maxRows * Constants.maxButtonsPerRow else { return }
//            let immoButton = ImmoButton(for: apartment)
//            immoButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing),
//                                      y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
//                                      width: Constants.immoButtonWidth,
//                                      height: Constants.buttonHeight)
//
//            let mapButton = MapButton(for: apartment)
//            mapButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing) + Constants.immoButtonWidth + Constants.apartSpacing,
//                                     y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
//                                     width: Constants.mapButtonsWidth,
//                                     height: Constants.buttonHeight)
//
//            index += 1
//            self.addSubview(immoButton)
//            self.addSubview(mapButton)
//        }
//    }
}
