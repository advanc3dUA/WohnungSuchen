//
//  Int+String.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.04.2023.
//

import Foundation

extension Int: Extractable {
    init(extractFrom string: String?, defaultValue: Int) {
        guard let string = string else {
            self = defaultValue
            return
        }
        self = Int(string) ?? defaultValue
    }
}
