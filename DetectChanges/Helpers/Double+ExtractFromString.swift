//
//  Double+ExtractFromString.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.04.2023.
//

import Foundation

extension Double: Extractable {
    init(extractFrom string: String?, defaultValue: TimeInterval) {
        guard let string = string else {
            self = defaultValue
            return
        }
        self = TimeInterval(string) ?? defaultValue
    }
}
