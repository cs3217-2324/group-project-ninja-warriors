//
//  PlayerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class PlayerWrapper: EntityWrapper {
   var components: [ComponentWrapper]?

    override init(id: EntityID, shape: ShapeWrapper) {
        super.init(id: id, shape: shape)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return Player(id: id, shape: shape.toShape())
    }
}
