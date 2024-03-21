//
//  CodableWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 21/3/24.
//

import Foundation

@propertyWrapper
struct CodableWrapper<T: Codable>: Codable {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(T.self)
    }
}
