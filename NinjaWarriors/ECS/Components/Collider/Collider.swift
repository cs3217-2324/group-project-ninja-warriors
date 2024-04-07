//
//  Collider.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

class Collider: Component {
    var colliderShape: Shape
    var collidedEntities: Set<EntityID>
    var isColliding: Bool
    var isOutOfBounds: Bool

    init(id: ComponentID, entity: Entity, colliderShape: Shape,
         collidedEntities: Set<EntityID> = [], isColliding: Bool, isOutOfBounds: Bool) {
        self.colliderShape = colliderShape
        self.collidedEntities = collidedEntities
        self.isColliding = isColliding
        self.isOutOfBounds = isOutOfBounds

        super.init(id: id, entity: entity)
    }

    func movePosition(by vector: Vector) {
        if isColliding || isOutOfBounds {
            colliderShape.offset = colliderShape.offset.add(vector: vector)
        } else {
            colliderShape.center = colliderShape.center.add(vector: vector)
        }
    }

    func getPosition() -> Point {
        colliderShape.center
    }

    func distanceTo(collider: Collider) -> Double {
        self.getPosition().distance(to: collider.getPosition())
    }

    func deepCopy() -> Collider {
        Collider(id: id, entity: entity.deepCopy(), colliderShape: colliderShape.deepCopy(),
                 isColliding: isColliding, isOutOfBounds: isOutOfBounds)
    }

    override func updateAttributes(_ newCollider: Component) {
        guard let newCollider = newCollider as? Collider else {
            return
        }
        //self.colliderShape.updateAttributes(newCollider.colliderShape)
        self.collidedEntities = newCollider.collidedEntities
        self.isColliding = newCollider.isColliding
        self.isOutOfBounds = newCollider.isOutOfBounds
    }

    override func changeEntity(to entity: Entity) -> Component {
        Collider(id: self.id, entity: entity, colliderShape: self.colliderShape, collidedEntities: self.collidedEntities, isColliding: self.isColliding, isOutOfBounds: self.isOutOfBounds)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }

        return ColliderWrapper(id: id, entity: entityWrapper,
                               colliderShape: colliderShape.wrapper(),
                               collidedEntities: collidedEntities,
                               isColliding: isColliding, isOutOfBounds: isOutOfBounds,
                               wrapperType: NSStringFromClass(type(of: entityWrapper)))
    }
}
