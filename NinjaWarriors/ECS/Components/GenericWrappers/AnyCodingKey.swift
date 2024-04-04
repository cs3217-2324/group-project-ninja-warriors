//
//  AnyCodingKey.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

// TODO: Remove hardcode wrap, add dictionary for health and score, add collision fields, add host

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
