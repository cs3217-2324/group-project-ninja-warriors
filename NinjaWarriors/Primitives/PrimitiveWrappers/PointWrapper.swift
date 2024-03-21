//
//  PointWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct PointWrapper: Codable {
    @CodableWrapper var xCoord: Double
    @CodableWrapper var yCoord: Double
    @CodableWrapper var radial: Double
    @CodableWrapper var theta: Double

    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        xCoord = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "xCoord"))
        yCoord = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "yCoord"))
        radial = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "radial"))
        theta = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "theta"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(xCoord, forKey: AnyCodingKey(stringValue: "xCoord"))
        try container.encode(yCoord, forKey: AnyCodingKey(stringValue: "yCoord"))
        try container.encode(radial, forKey: AnyCodingKey(stringValue: "radial"))
        try container.encode(theta, forKey: AnyCodingKey(stringValue: "theta"))
    }
    */

    func toPoint() -> Point {
        return Point(xCoord: xCoord, yCoord: yCoord)
    }
}
