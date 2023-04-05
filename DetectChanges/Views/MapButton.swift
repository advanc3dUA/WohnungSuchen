//
//  MapButton.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 17.03.2023.
//

import UIKit

@IBDesignable
class MapButton: UIButton {
//    var street = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .black
        setTitleColor(.systemGreen, for: .normal)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGreen.cgColor
        setTitle("🧭", for: .normal)
//        self.street = apartment.street
//        self.addTarget(self, action: #selector(mapButtonTapped(_:)), for: .touchUpInside)
    }
    
//    @objc func mapButtonTapped(_ sender: MapButton) {
//        guard let address = sender.street.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        var urlString: String
//        #if targetEnvironment(macCatalyst)
//            urlString = "https://www.google.com/maps/search/\(address)"
//        #else
//            urlString = "comgooglemaps://?q=\(address)&zoom=10"
//        #endif
//        if let url = URL(string: urlString) {
//            UIApplication.shared.open(url)
//        }
//    }

}
