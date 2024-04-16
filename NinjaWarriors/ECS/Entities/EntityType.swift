//
//  EntityType.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 28/3/24.
//

import Foundation

struct EntityType: Hashable {
    let type: Entity.Type

    init(_ type: Entity.Type) {
        self.type = type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    static func == (lhs: EntityType, rhs: EntityType) -> Bool {
        return lhs.type == rhs.type
    }
}
