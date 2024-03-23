//
//  ColliderWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

struct ColliderWrapper: ComponentWrapper {
    var id: EntityID
    var entity: EntityWrapper
    var colliderShape: ShapeWrapper
    var bounciness: Double
    var density: Double
    var restitution: Double
    var isColliding: Bool
    var offset: VectorWrapper

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Collider(id: id, entity: entity, colliderShape: colliderShape.toShape(),
                 bounciness: bounciness, density: density, restitution: restitution,
                 isColliding: isColliding, offset: offset.toVector())
    }
}
