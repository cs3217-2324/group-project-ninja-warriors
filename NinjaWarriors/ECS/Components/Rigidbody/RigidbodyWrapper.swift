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

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }

        if let colliderUnwrap = attachedCollider.toComponent() as? Collider {
            return Rigidbody(id: id, entity: entity, angularDrag: angularDrag,
                             angularVelocity: angularVelocity, mass: mass, rotation: rotation,
                             totalForce: totalForce.toVector(), inertia: inertia, position: position.toPoint(),
                             offset: offset.toPoint(), velocity: velocity.toVector(),
                             attachedCollider: colliderUnwrap)
        } else {
            return nil
        }
    }
}
