//
//  PointWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct PointWrapper: Codable {
    var xCoord: Double
    var yCoord: Double
    var radial: Double
    var theta: Double

    func toPoint() -> Point {
        return Point(xCoord: xCoord, yCoord: yCoord)
    }
}
