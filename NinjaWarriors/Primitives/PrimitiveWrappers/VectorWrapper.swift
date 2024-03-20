//
//  VectorWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct VectorWrapper: Codable {
    @CodableWrapper var horizontal: Double
    @CodableWrapper var vertical: Double

    init(horizontal: Double, vertical: Double) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        horizontal = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "horizontal"))
        vertical = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "vertical"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(horizontal, forKey: AnyCodingKey(stringValue: "horizontal"))
        try container.encode(vertical, forKey: AnyCodingKey(stringValue: "vertical"))
    }
    */

    func toVector() -> Vector {
        return Vector(horizontal: horizontal, vertical: vertical)
    }
}
