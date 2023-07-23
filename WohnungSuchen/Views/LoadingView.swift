//
//  LoadingView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 08.04.2023.
//

import UIKit

final class LoadingView: UIView {
    private var loadingLabel: UILabel
    private var activityIndicator: UIActivityIndicatorView

    override init(frame: CGRect) {
        let width = 100
        let height = 50
        let x = (Int(frame.width) - (width + height)) / 2
        let y = Int(frame.height) / 2
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: x, y: y, width: height, height: height))
        self.loadingLabel = UILabel(frame: CGRect(x: x + height, y: y, width: width, height: height))
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        loadingLabel.text = "Loading..."
        loadingLabel.backgroundColor = Color.brandGray.setColor
        loadingLabel.textColor = Color.brandDark.setColor
        
        activityIndicator.color = Color.brandDark.setColor
        activityIndicator.backgroundColor = Color.brandGray.setColor
        activityIndicator.startAnimating()
        
        self.addSubview(loadingLabel)
        self.addSubview(activityIndicator)
    }

}
