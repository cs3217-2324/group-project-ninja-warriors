//
//  PlayerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class PlayerWrapper: EntityWrapper {
    
    override init(id: EntityID) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return Player(id: id)
    }
}
