//
//  ModalView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 01.04.2023.
//

import UIKit
import Combine

final class ModalView: UIView {

    private(set) lazy var containerView: UIView = UIView()
    private(set) lazy var startPauseButton: StartPauseButton = StartPauseButton()
    private(set) lazy var optionsView: OptionsView = makeOptionsView()

    init() {
        super.init(frame: .zero)
        backgroundColor = Color.brandOlive.setColor
        setupStartPauseButton()
        optionsView.setupProvidersCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup views

    private func makeOptionsView() -> OptionsView {
        let optionsNib = UINib(nibName: "OptionsView", bundle: nil)
        guard let optionsView = optionsNib.instantiate(withOwner: self).first as? OptionsView else {
            return OptionsView()
        }
        return optionsView
    }

    func showOptionsContent() {
        self.addSubview(optionsView)
        optionsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            optionsView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            optionsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            optionsView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -5),
            optionsView.topAnchor.constraint(equalTo: centerYAnchor, constant: -325)
        ])
    }

    func hideOptionsContent() {
        optionsView.removeFromSuperview()
    }

    private func setupStartPauseButton() {
        let buttonsWidth = 75
        let buttonsHeight = 50

        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Color.brandOlive.setColor
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth)),
            containerView.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])

        startPauseButton = StartPauseButton()
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(startPauseButton)
        NSLayoutConstraint.activate([
            startPauseButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonsWidth)),
            startPauseButton.heightAnchor.constraint(equalToConstant: CGFloat(buttonsHeight)),
            startPauseButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            startPauseButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
}
