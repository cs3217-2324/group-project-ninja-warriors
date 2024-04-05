//
//  RigidbodyWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

struct RigidbodyWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var angularDrag: Double
    var angularVelocity: Double
    var mass: Double
    var rotation: Double
    var totalForce: VectorWrapper
    var inertia: Double
    var position: PointWrapper
    var offset: PointWrapper
    var velocity: VectorWrapper
    var attachedCollider: ColliderWrapper
    var wrapperType: String

    func toComponent() -> (Component, Entity)? {

        if let entity = entity as? PlayerWrapper {
            guard let entity = entity.toEntity() else {
                return nil
            }

            if let colliderEntityUnwrap = attachedCollider.toComponent() as? (Collider, Entity) {
                return (Rigidbody(id: id, entity: entity, angularDrag: angularDrag,
                                 angularVelocity: angularVelocity, mass: mass, rotation: rotation,
                                 totalForce: totalForce.toVector(), inertia: inertia, position: position.toPoint(),
                                 offset: offset.toPoint(), velocity: velocity.toVector(),
                                  attachedCollider: colliderEntityUnwrap.0), colliderEntityUnwrap.1)
            } else {
                return nil
            }
        } else if let entity = entity as? ObstacleWrapper {
            guard let entity = entity.toEntity() else {
                return nil
            }

            if let colliderEntityUnwrap = attachedCollider.toComponent() as? (Collider, Entity) {
                return (Rigidbody(id: id, entity: entity, angularDrag: angularDrag,
                                 angularVelocity: angularVelocity, mass: mass, rotation: rotation,
                                 totalForce: totalForce.toVector(), inertia: inertia, position: position.toPoint(),
                                 offset: offset.toPoint(), velocity: velocity.toVector(),
                                  attachedCollider: colliderEntityUnwrap.0), colliderEntityUnwrap.1)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
