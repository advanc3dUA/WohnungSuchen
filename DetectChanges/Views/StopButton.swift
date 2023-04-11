//
//  StopButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 08.04.2023.
//

import UIKit

class StopButton: UIButton {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let imageSize = CGSize(width: 40, height: 35)
        let imageRenderer = UIGraphicsImageRenderer(size: imageSize)
        let image = imageRenderer.image { context in
            let imageBounds = CGRect(origin: .zero, size: imageSize)
            UIImage(systemName: "stop")?
                .withTintColor(Colour.brandDark.setColor!, renderingMode: .alwaysOriginal)
                .draw(in: imageBounds)
        }
        setImage(image, for: .normal)
        
        frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Colour.brandDark.setColor?.cgColor
        backgroundColor = Colour.brandBlue.setColor
    }
}
