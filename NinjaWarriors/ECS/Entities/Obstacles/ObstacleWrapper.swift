//
//  ObstacleWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class ObstacleWrapper: EntityWrapper {

    override init(id: EntityID) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return Obstacle(id: id)
    }
}
