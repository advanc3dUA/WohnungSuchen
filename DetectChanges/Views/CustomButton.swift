//
//  CustomButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 19.04.2023.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
    }
    
    func imageWithColor(_ color: UIColor, cornerRadius: CGFloat = 0.0) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        let image = renderer.image { context in
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            color.setFill()
            path.fill()
            
            // Set the clip bounds to the same corner radius
            context.cgContext.addPath(path.cgPath)
            context.cgContext.clip()
        }
        
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }
}
