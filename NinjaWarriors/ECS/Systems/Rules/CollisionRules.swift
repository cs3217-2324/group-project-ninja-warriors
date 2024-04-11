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

        guard let manager = manager, let collidingEntity = object.attachedCollider?.collidedEntities.first,
              let otherObject = manager.getComponentFromId(ofType: Rigidbody.self, of: collidingEntity) else {
            return true
        }

        if let _ = object.entity as? Player, let _ = otherObject.entity as? Gem {
            otherObject.velocity = Vector(horizontal: 0.0, vertical: -3.0)
            return true
        }

        if let _ = object.entity as? Gem, let _ = otherObject.entity as? Player {
            object.velocity = Vector(horizontal: 0.0, vertical: -3.0)
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

            killCollidee(ofType: Gem.self)

        } else if let collider = object.attachedCollider, collider.isColliding || collider.isOutOfBounds {
            object.collidingVelocity = input
            object.velocity = Vector.zero
        }

        moveRigidBody(object, across: deltaTime)
        object.attachedCollider?.colliderShape.center = object.position
    }

    private func killCollidee<T: Entity>(ofType entityType: T.Type) {
        if let manager = manager,
           let collidingEntityID = object.attachedCollider?.collidedEntities.first,
           let collidingEntity = manager.entity(with: collidingEntityID) as? T,
           let health = manager.getComponent(ofType: Health.self, for: collidingEntity) {
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
        let deltaPosition = currentVelocity.scale(deltaTime).add(vector: rigidBody.acceleration.scale(0.5 * pow(deltaTime, 2)))
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
