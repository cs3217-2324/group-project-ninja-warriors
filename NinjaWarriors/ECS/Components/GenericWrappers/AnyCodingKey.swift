//
//  AnyCodingKey.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
