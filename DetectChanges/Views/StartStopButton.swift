//
//  StartStopButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 31.03.2023.
//

import UIKit

enum ImageState: String {
    case stop = "stop"
    case play = "play"
}

class StartStopButton: UIButton {
    var isOn = false
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        switchOff()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        layer.cornerRadius = 35
        layer.borderWidth = 1
    }
    
    func switchOn() {
        layer.borderColor = Colour.brandDark.setColor?.cgColor
        backgroundColor = Colour.brandBlue.setColor
        isOn = true
        switchImage(to: .play)
    }
    
    func switchOff() {
        layer.borderColor = Colour.brandBlue.setColor?.cgColor
        backgroundColor = Colour.brandDark.setColor
        isOn = false
        switchImage(to: .stop)
    }
    
    private func switchImage(to imageState: ImageState) {
        let imageSize = CGSize(width: 40, height: 40)
        let imageRenderer = UIGraphicsImageRenderer(size: imageSize)
        let image = imageRenderer.image { context in
            let imageBounds = CGRect(origin: .zero, size: imageSize)
            UIImage(systemName: imageState.rawValue)?.draw(in: imageBounds)
        }
        setImage(image, for: .normal)
    }
}

