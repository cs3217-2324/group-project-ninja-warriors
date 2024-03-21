//
//  LineWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct LineWrapper: Codable {
    /*@CodableWrapper*/ var start: PointWrapper
    /*@CodableWrapper*/ var end: PointWrapper
    /*@CodableWrapper*/ var vector: VectorWrapper

    func toLine() -> Line {
        let startPoint = Point(xCoord: start.xCoord, yCoord: start.yCoord)
        let endPoint = Point(xCoord: end.xCoord, yCoord: end.yCoord)
        return Line(start: startPoint, end: endPoint)
    }
}
