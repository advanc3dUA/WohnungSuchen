//
//  Company.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 05.04.2023.
//

import UIKit

enum Company {
    case saga
    case vonovia
    case unknown
    
    var logoImage: UIImage? {
        switch self {
        case .saga: return UIImage(named: "SagaLogo.jpg")
        case .vonovia: return UIImage(named: "VonoviaLogo.jpg")
        case .unknown: return nil
        }
    }
}
