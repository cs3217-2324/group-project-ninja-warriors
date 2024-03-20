//
//  PointWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct PointWrapper: Codable {
    let xCoord: Double
    let yCoord: Double
    let radial: Double
    let theta: Double

    init(xCoord: Double, yCoord: Double, radial: Double, theta: Double) {
        self.xCoord = xCoord
        self.yCoord = yCoord
        self.radial = radial
        self.theta = theta
    }

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

    func toPoint() -> Point {
        return Point(xCoord: xCoord, yCoord: yCoord)
    }
}
