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
            return object.entity as? Hadouken == nil ? false : true
        }

        guard let manager = manager, let collideeEntityID = object.attachedCollider?.collidedEntities.first,
              let collideeEntity = manager.entity(with: collideeEntityID) else {
            return true
        }

        if object.entity as? Player != nil, collideeEntity as? Gem != nil {
            return true
        }

        if object.entity as? Gem != nil, collideeEntity as? Player != nil {
            return true
        }

        if object.entity as? Hadouken != nil, collideeEntity as? Player != nil {
            return true
        }

        if object.entity as? Player != nil, collideeEntity as? Hadouken != nil {
            return true
        }
        return false
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

            performActionOnCollidee(ofType: Gem.self)
            performAction(colliderType: Hadouken.self, collideeType: Player.self)
            performAction(colliderType: Player.self, collideeType: Hadouken.self)

        /*
        } else if object.entity as? Hadouken != nil,
                  let collider = object.attachedCollider,
                  collider.isOutOfBounds {
            object.velocity = input
            object.collidingVelocity = nil
            object.attachedCollider?.isColliding = false
        */
        } else if let collider = object.attachedCollider, collider.isColliding || collider.isOutOfBounds {
            /*
            if object.entity as? Hadouken != nil {
                manager?.remove(entity: object.entity, isRemoved: false)
            }
            */

            object.collidingVelocity = input
            object.velocity = Vector.zero
        }

        moveRigidBody(object, across: deltaTime)
        object.attachedCollider?.colliderShape.center = object.position
    }

    private func performActionOnCollidee<T: Entity>(ofType entityType: T.Type) {
        guard let manager = manager,
              let collidingEntityID = object.attachedCollider?.collidedEntities.first,
              let collidingEntity = manager.entity(with: collidingEntityID) as? T else {
            return
        }

        if let health = manager.getComponent(ofType: Health.self, for: collidingEntity) {
            health.kill()
        }
    }

    private func performAction<T: Entity, V: Entity>(colliderType: T.Type, collideeType: V.Type) {
        guard let manager = manager, let collideeEntityID = object.attachedCollider?.collidedEntities.first,
              let collideeEntity = manager.entity(with: collideeEntityID),
              let hadoukenEntity = object.entity as? Hadouken,
              collideeEntity as? Player != nil,
              collideeEntity.id != hadoukenEntity.casterEntity.id else {
            return
        }

        if let health = manager.getComponent(ofType: Health.self, for: collideeEntity) {
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
}
