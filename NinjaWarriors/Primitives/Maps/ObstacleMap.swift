//
//  ObstacleMap.swift
//  NinjaWarriors
//
//  Created by Muhammad  Reyaaz on 13/4/24.
//

import Foundation

class ObstacleMap: Map {
    internal let mapBg = "blue-wall"
    internal var mapEntities: [Entity] = []

    func getPositions() -> [Point] {
        let screenWidth = Constants.screenWidth
        let screenHeight = Constants.screenHeight
        let obstacleCount = Constants.obstacleCount

        let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
        let radius: Double = 250
        let gapAngle: Double = 2 * .pi / Double(obstacleCount)
        var positions: [Point] = []

        for index in 0..<obstacleCount {
            let angle = Double(index) * gapAngle
            let newX = center.xCoord + radius * cos(angle)
            let newY = center.yCoord + radius * sin(angle)
            positions.append(Point(xCoord: newX, yCoord: newY))
        }
        return positions
    }

    func getMapEntities() -> [Entity] {
        let positions: [Point] = getPositions()

        for index in 0..<Constants.obstacleCount {
            let position = positions[index]
            let obstacle = Obstacle(id: RandomNonce().randomNonceString(), position: position)
            mapEntities.append(obstacle)
        }
        return mapEntities
    }

}
