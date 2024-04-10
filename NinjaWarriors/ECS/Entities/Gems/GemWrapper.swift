//
//  GemWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 10/4/24.
//

import Foundation

class GemWrapper: EntityWrapper {

    override init(id: EntityID) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return Gem(id: id)
    }
}
