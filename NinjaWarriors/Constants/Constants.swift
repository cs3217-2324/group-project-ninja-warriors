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

    // MARK: Player intial positions
    static let playerOnePosition = Point(xCoord: 100, yCoord: 100)
    static let playerTwoPosition = Point(xCoord: screenWidth - 100, yCoord: 100)
    static let playerThreePosition = Point(xCoord: 100, yCoord: screenHeight - 500)
    static let playerFourPosition = Point(xCoord: screenWidth - 100, yCoord: screenHeight - 500)
    static let playerPositions = [playerOnePosition, playerTwoPosition,
                                  playerThreePosition, playerFourPosition]

    // TODO: Reset to 4 after testing
    static let playerCount = 1

    static let obstacleCount = 1

    static let slashDamage = 10.0
    static let slashRadius = 75.0
    
    struct DodgeImage {
        static let image = "dodge"
        static let width: CGFloat = 100
        static let height: CGFloat = 100
    }
    
    struct HealthBar {
        static let height: CGFloat = 10
        static let offsetY: CGFloat = 15
    }

    static var closingZonePosition: Point { Point(xCoord: screenWidth / 2.0, yCoord: screenHeight / 2.0 - 100) }
    static var closingZoneRadius: Double { screenHeight / 2.5 }
    static var closingZoneDPS: Double = 1.0
    static var closingZoneRadiusShrinkagePerSecond: Double = 10.0
    static var closingZoneMinimumSize: Double = 50.0
}
