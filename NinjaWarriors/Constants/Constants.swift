//
//  Constants.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation
import SwiftUI

struct Constants {
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenWidth = UIScreen.main.bounds.size.width
    static let defaultSize: CGFloat = 25.0
    static let directory = "NinjaWarriors."
    static let wrapperName = "Wrapper"

    // MARK: Players initial positions
    static let playerOnePosition = Point(xCoord: 100, yCoord: 100)
    static let playerTwoPosition = Point(xCoord: screenWidth - 100, yCoord: 100)
    static let playerThreePosition = Point(xCoord: 100, yCoord: screenHeight - 500)
    static let playerFourPosition = Point(xCoord: screenWidth - 100, yCoord: screenHeight - 500)
    static let playerPositions = [playerOnePosition, playerTwoPosition, playerThreePosition, playerFourPosition]
    // TODO: Reset to 4 after testing
    static let playerCount = 2

    // MARK: Obstacles initial positions

    /*
    static let obstacleOnePosition = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
    static let obstacleTwoPosition = Point(xCoord: 200, yCoord: 500)
    static let obstacleThreePosition = Point(xCoord: 500, yCoord: 500)
    static let obstacleFourPosition = Point(xCoord: 400, yCoord: 600)
    static let obstacleFivePosition = Point(xCoord: 400, yCoord: 300)
    static let obstacleSixPosition = Point(xCoord: 300, yCoord: 250)

    static let obstaclePositions = [obstacleOnePosition, obstacleTwoPosition, obstacleThreePosition, obstacleFourPosition, obstacleFivePosition, obstacleSixPosition]

    static let obstacleCount = 6
    */

    static let obstacleCount = 1 // Increase obstacle count for more positions

    static let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2) // Center of the circle
    static let radius: Double = 200 // Radius of the circle
    static let gapAngle: Double = 2.5 * .pi / Double(obstacleCount) // Angle between each obstacle

    static var obstaclePositions: [Point] {
        var positions: [Point] = []
        for i in 0..<obstacleCount {
            let angle = Double(i) * gapAngle
            let x = center.xCoord + radius * cos(angle)
            let y = center.yCoord + radius * sin(angle)
            positions.append(Point(xCoord: x, yCoord: y))
        }
        return positions
    }

}
