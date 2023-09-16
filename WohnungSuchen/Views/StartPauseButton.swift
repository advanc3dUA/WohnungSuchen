//
//  StartPauseButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 31.03.2023.
//

import UIKit

final class StartPauseButton: UIButton {
    private(set) var isOn = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        switchOff()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }

    func switchOn() {
        layer.borderColor = Color.brandBlue.setColor?.cgColor
        backgroundColor = Color.brandDark.setColor
        isOn = true
        switchImage(to: .play, color: Color.brandBlue.setColor)
    }

    func switchOff() {
        layer.borderColor = Color.brandDark.setColor?.cgColor
        backgroundColor = Color.brandBlue.setColor
        isOn = false
        switchImage(to: .pause, color: Color.brandDark.setColor)
    }

    private func switchImage(to imageState: ImageState, color: UIColor?) {
        guard let color = color else { return }
        let imageSize = CGSize(width: 40, height: 35)
        let imageRenderer = UIGraphicsImageRenderer(size: imageSize)
        let image = imageRenderer.image { _ in
            let imageBounds = CGRect(origin: .zero, size: imageSize)
            UIImage(systemName: imageState.rawValue)?
                .withTintColor(color, renderingMode: .alwaysOriginal)
                .draw(in: imageBounds)
        }
        setImage(image, for: .normal)
    }
}

extension StartPauseButton {
    enum ImageState: String {
        case pause
        case play
    }
}
