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
    static let playerTwoPosition = Point(xCoord: 300, yCoord: 300)
    static let playerThreePosition = Point(xCoord: 500, yCoord: 500)
    static let playerFourPosition = Point(xCoord: 700, yCoord: 700)
    static let playerPositions = [playerOnePosition, playerTwoPosition, playerThreePosition, playerFourPosition]
    // TODO: Reset to 4 after testing
    static let playerCount = 1
}
