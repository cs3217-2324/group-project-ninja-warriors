//
//  Collider.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

class Collider: Component {
    var colliderShape: Shape
    // TODO: Change to Set<Entity>
    var collidedEntities: Set<EntityID>
    var isColliding: Bool = false

    init(id: EntityID, entity: Entity, colliderShape: Shape, collidedEntities: Set<EntityID> = []) {
        self.colliderShape = colliderShape
        self.collidedEntities = collidedEntities

        super.init(id: id, entity: entity)
    }

    func movePosition(by vector: Vector) {
        colliderShape.center = colliderShape.center.add(vector: vector)
    }

    func getPosition() -> Point {
        colliderShape.center
    }

    func distanceTo(collider: Collider) -> Double {
        self.getPosition().distance(to: collider.getPosition())
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return ColliderWrapper(id: id, entity: entityWrapper,
                               colliderShape: colliderShape.toShapeWrapper(),
                               collidedEntities: collidedEntities)
    }
}
