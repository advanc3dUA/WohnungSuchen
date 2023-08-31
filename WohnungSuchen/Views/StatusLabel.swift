//
//  StatusLabel.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 31.08.2023.
//

import UIKit

final class StatusLabel: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    func update(receivedError: Bool) {
        if receivedError {
            self.backgroundColor = Color.brandRed.setColor
            self.textColor = .white
            self.text = "Last error occurred: \(TimeManager.shared.getCurrentTime())"
        } else {
            self.backgroundColor = Color.brandOlive.setColor
            self.textColor = Color.brandDark.setColor
            self.text = "Last update: \(TimeManager.shared.getCurrentTime())"
        }
        self.flash(numberOfFlashes: 1)
    }
}
