//
//  CollisionRules.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 10/4/24.
//

import Foundation

class CollisionRules: Rules {
    private var object: Rigidbody
    private var input: Vector?
    internal var manager: EntityComponentManager?
    internal var deltaTime: TimeInterval?

    init(object: Rigidbody, input: Vector? = nil, deltaTime: TimeInterval? = nil,
         manager: EntityComponentManager? = nil) {
        self.object = object
        self.input = input
        self.deltaTime = deltaTime
        self.manager = manager
    }

    func canMove() -> Bool {
        if let collider = object.attachedCollider, !collider.isColliding && !collider.isOutOfBounds {
            return true
        }

        if let collider = object.attachedCollider, collider.isOutOfBounds {
            return false
        }

        guard let manager = manager, let collideeEntityID = object.attachedCollider?.collidedEntities.first,
              let collideeEntity = manager.entity(with: collideeEntityID) else {
            return true
        }
        return canPassThrough(object.entity, collideeEntity)
    }

    func performRule() {
        guard let input = input, let deltaTime = deltaTime else {
            return
        }

        if canMove() {
            object.velocity = input
            object.collidingVelocity = nil
            object.attachedCollider?.isColliding = false

            if input.horizontal != 0 || input.vertical != 0 {
                alignEntityRotation(for: object)
            }

            // Only allow entity with collector component to collect collectable component
            if manager?.getComponent(ofType: Collector.self, for: object.entity) != nil,
               let collidingEntityID = object.attachedCollider?.collidedEntities.first,
               let collidingEntity = manager?.entity(with: collidingEntityID),
               manager?.getComponent(ofType: Collectable.self, for: collidingEntity) != nil {
                performAction(on: collidingEntity)
            }

        } else if let collider = object.attachedCollider, collider.isColliding || collider.isOutOfBounds {
            object.collidingVelocity = input
            object.velocity = Vector.zero

            // Stop any skills moving when it collides
            /*
            if var objectLifespan = manager?.getComponent(ofType: Lifespan.self, for: object.entity) {
                objectLifespan.elapsedTime = objectLifespan.lifespan
            }
            */
        }

        moveRigidBody(object, across: deltaTime)
        object.attachedCollider?.colliderShape.center = object.position
    }

    private func performAction(on entity: Entity) {
        if let health = manager?.getComponent(ofType: Health.self, for: entity) {
            health.kill()
        }
    }

    private func alignEntityRotation(for rigidBody: Rigidbody) {
        guard let input = input else {
            return
        }
        let radians = atan2(input.vertical, input.horizontal)
        let degrees = radians * 180 / .pi
        rigidBody.rotation = degrees
    }

    private func moveRigidBody(_ rigidBody: Rigidbody, across deltaTime: TimeInterval) {
        var currentVelocity = rigidBody.collidingVelocity ?? rigidBody.velocity

        // Update position
        let deltaPosition = currentVelocity.scale(deltaTime)
            .add(vector: rigidBody.acceleration.scale(0.5 * pow(deltaTime, 2)))
        rigidBody.movePosition(by: deltaPosition)

        // Update velocity
        currentVelocity = currentVelocity.add(vector: rigidBody.acceleration.scale(deltaTime))

        if rigidBody.collidingVelocity != nil {
            rigidBody.collidingVelocity = currentVelocity
        } else {
            rigidBody.velocity = currentVelocity
        }

        // Reset force
        rigidBody.totalForce = Vector.zero
    }

    func canPassThrough(_ colliderEntity: Entity, _ collideeEntity: Entity) -> Bool {
        if manager?.getComponent(ofType: PlayerComponent.self, for: colliderEntity) != nil &&
            manager?.getComponent(ofType: PlayerComponent.self, for: collideeEntity) != nil {
            return false
        }

        if manager?.getComponent(ofType: Invisible.self, for: colliderEntity) != nil &&
            manager?.getComponent(ofType: Invisible.self, for: collideeEntity) != nil {
            return true
        }
        return false
    }
}
