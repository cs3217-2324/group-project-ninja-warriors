//
//  ObstacleMap.swift
//  NinjaWarriors
//
//  Created by Muhammad  Reyaaz on 13/4/24.
//

import Foundation

class ObstacleMap: Map {
    internal let gameMode: GameMode = LastManStandingMode() // TODO: Add a respawn mode
    internal let mapBackground = "blue-wall"
    internal var mapEntities: [Entity] = []

    func getPositions() -> [Point] {
        let screenWidth = Constants.screenWidth
        let screenHeight = Constants.screenHeight
        let obstacleCount = Constants.obstacleCount

        let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
        let radius: Double = 250
        let gapAngle: Double = 2 * .pi / Double(obstacleCount)
        var positions: [Point] = []

        for i in 0..<obstacleCount {
            let angle = Double(i) * gapAngle
            let x = center.xCoord + radius * cos(angle)
            let y = center.yCoord + radius * sin(angle)
            positions.append(Point(xCoord: x, yCoord: y))
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
