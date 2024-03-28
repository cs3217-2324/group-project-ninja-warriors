//
//  AnyEntity.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 28/3/24.
//

import Foundation

struct AnyEntity: Hashable {
    private let entity: Entity

    init(_ entity: Entity) {
        self.entity = entity
    }

    func getEntity() -> Entity {
        entity
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(entity))
    }

    static func == (lhs: AnyEntity, rhs: AnyEntity) -> Bool {
        return ObjectIdentifier(lhs.entity) == ObjectIdentifier(rhs.entity)
    }
}
