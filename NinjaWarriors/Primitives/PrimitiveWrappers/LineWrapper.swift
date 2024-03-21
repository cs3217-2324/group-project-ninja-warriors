//
//  LineWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct LineWrapper: Codable {
    var start: PointWrapper
    var end: PointWrapper
    var vector: VectorWrapper

    func toLine() -> Line {
        let startPoint = Point(xCoord: start.xCoord, yCoord: start.yCoord)
        let endPoint = Point(xCoord: end.xCoord, yCoord: end.yCoord)
        return Line(start: startPoint, end: endPoint)
    }
}
