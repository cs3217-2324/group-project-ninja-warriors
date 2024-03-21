//
//  LineWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct LineWrapper: Codable {
    @CodableWrapper var start: PointWrapper
    @CodableWrapper var end: PointWrapper
    @CodableWrapper var vector: VectorWrapper

    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        start = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "start"))
        end = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "end"))
        vector = try container.decode(VectorWrapper.self, forKey: AnyCodingKey(stringValue: "vector"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(start, forKey: AnyCodingKey(stringValue: "start"))
        try container.encode(end, forKey: AnyCodingKey(stringValue: "end"))
        try container.encode(vector, forKey: AnyCodingKey(stringValue: "vector"))
    }
    */

    func toLine() -> Line {
        let startPoint = Point(xCoord: start.xCoord, yCoord: start.yCoord)
        let endPoint = Point(xCoord: end.xCoord, yCoord: end.yCoord)
        return Line(start: startPoint, end: endPoint)
    }
}
