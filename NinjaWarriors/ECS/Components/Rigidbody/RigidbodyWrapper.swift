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
    var totalForce: Double
    var gravityScale: Double
    var gravity: Double
    var inertia: Double
    var attachedColliderCount: Int
    var collisionDetectionMode: Bool
    var position: PointWrapper
    var velocity: VectorWrapper
    var attachedColliders: [ColliderWrapper]

    func toComponent() -> Component? {
        var collidersUnwrap: [Collider] = []
        for colliderWrap in attachedColliders {
            if let colliderUnwrap = colliderWrap.toComponent() as? Collider {
                collidersUnwrap.append(colliderUnwrap)
            }
        }

        guard let entity = entity.toEntity() else {
            return nil
        }

        return Rigidbody(id: id, entity: entity, angularDrag: angularDrag, angularVelocity: angularVelocity, mass: mass, rotation: rotation, totalForce: totalForce, gravityScale: gravityScale, gravity: gravity, inertia: inertia, attachedColliderCount: attachedColliderCount, collisionDetectionMode: collisionDetectionMode, position: position.toPoint(), velocity: velocity.toVector(), attachedColliders: collidersUnwrap)
    }
}
