//
//  GemMap.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

class GemMap: Map {
    internal var manager: RealTimeManagerAdapter
    internal var fixedEntities: [Entity] = []

    init(manager: RealTimeManagerAdapter) {
        self.manager = manager
    }

    func startMap() {
        populateFixedEntities()
        addEntities()
    }

    func getPositions() -> [Point] {
        let screenWidth = Constants.screenWidth
        let screenHeight = Constants.screenHeight
        let gemCount = Constants.gemCount

        let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
        let radius: Double = 100
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

    func populateFixedEntities() {
        let positions: [Point] = getPositions()
        for index in 0..<Constants.gemCount {
            let position = positions[index]
            let gem = Gem(id: RandomNonce().randomNonceString(), position: position)
            fixedEntities.append(gem)
        }
    }

    func addEntities() {
        for fixedEntity in fixedEntities {
            Task {
                try? await manager.uploadEntity(entity: fixedEntity,
                                                components: fixedEntity.getInitializingComponents())
            }
        }
    }
}
