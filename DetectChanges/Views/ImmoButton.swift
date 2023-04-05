//
//  ImmoButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.03.2023.
//

import UIKit

@IBDesignable
class ImmoButton: UIButton {
//    var immomioLink = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .systemGreen
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        setTitle("🔗", for: .normal)
//        self.immomioLink = apartment.immomioLink
//        self.addTarget(self, action: #selector(immoButtonTapped(_:)), for: .touchUpInside)
    }
    
//    @objc func immoButtonTapped(_ sender: ImmoButton) {
//        guard let url = URL(string: sender.immomioLink) else { return }
//        UIApplication.shared.open(url)
//    }
}
