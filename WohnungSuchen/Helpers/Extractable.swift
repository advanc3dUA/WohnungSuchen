//
//  Extractable.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 22.04.2023.
//

import Foundation

protocol Extractable {
    init(extractFrom: String?, defaultValue: Self)
}
