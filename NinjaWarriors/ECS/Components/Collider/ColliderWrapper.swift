//
//  ColliderWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

struct ColliderWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var colliderShape: ShapeWrapper
    var collidedEntities: Set<EntityID>

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Collider(id: id, entity: entity, colliderShape: colliderShape.toShape(), collidedEntities: collidedEntities)
    }
}
