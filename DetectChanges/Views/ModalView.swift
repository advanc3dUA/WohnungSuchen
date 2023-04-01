//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit

class ModalView: UIView {
    
    var superView: UIView
    var buttonsContainerView: ButtonsContainerView!
    
    init(for superView: UIView) {
        self.superView = superView
        super.init(frame: superView.bounds)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .darkGray
        setupButtonsContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonsContainerView() {
        buttonsContainerView = ButtonsContainerView(for: self)
        addSubview(buttonsContainerView)
        
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: (Constants.buttonHeight + Constants.spacing) * CGFloat(Constants.maxRows) - Constants.spacing)
         ])
    }
}

