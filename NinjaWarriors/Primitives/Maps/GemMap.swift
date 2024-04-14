//
//  GemMap.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

class GemMap: Map {
    internal let mapBg = "gray-wall"
    internal var mapEntities: [Entity] = []

    func getPositions() -> [Point] {
        let screenWidth = Constants.screenWidth
        let screenHeight = Constants.screenHeight
        let gemCount = Constants.gemCount

        let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
        let radius: Double = 250
        let gapAngle: Double = 2 * .pi / Double(gemCount)
        var positions: [Point] = []

        for index in 0..<gemCount {
            let angle = Double(index) * gapAngle
            let newX = center.xCoord + radius * cos(angle)
            let newY = center.yCoord + radius * sin(angle)
            positions.append(Point(xCoord: newX, yCoord: newY))
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
