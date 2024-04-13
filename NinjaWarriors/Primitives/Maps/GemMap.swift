//
//  GemMap.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

class GemMap: Map {
    internal let mapBackground = "gray-wall"
    internal var mapEntities: [Entity] = []

    func getPositions() -> [Point] {
        let screenWidth = Constants.screenWidth
        let screenHeight = Constants.screenHeight
        let gemCount = Constants.gemCount

        let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
        let radius: Double = 250
        let gapAngle: Double = 2 * .pi / Double(gemCount)
        var positions: [Point] = []

        for i in 0..<gemCount {
            let angle = Double(i) * gapAngle
            let x = center.xCoord + radius * cos(angle)
            let y = center.yCoord + radius * sin(angle)
            positions.append(Point(xCoord: x, yCoord: y))
        }
        return positions
    }

    func getMapEntities() -> [Entity] {
        let positions: [Point] = getPositions()

        for index in 0..<Constants.gemCount {
            let position = positions[index]
            let gem = Gem(id: RandomNonce().randomNonceString(), position: position)
            mapEntities.append(gem)
        }
        return mapEntities
    }
}
