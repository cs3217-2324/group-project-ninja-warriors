//
//  CollisionRules.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 10/4/24.
//

import Foundation

class CollisionRules {
    private var object: Rigidbody
    private var input: Vector
    private var deltaTime: TimeInterval
    private var manager: EntityComponentManager

    init(object: Rigidbody, input: Vector, deltaTime: TimeInterval, manager: EntityComponentManager) {
        self.object = object
        self.input = input
        self.deltaTime = deltaTime
        self.manager = manager
    }

    func canMove() -> Bool {
        if let collider = object.attachedCollider, !collider.isColliding && !collider.isOutOfBounds {
            return true
        }

        guard let collidingEntity = object.attachedCollider?.collidedEntities.first,
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
        if canMove() {
            object.velocity = input
            object.collidingVelocity = nil

            if input.horizontal != 0 || input.vertical != 0 {
                alignEntityRotation(for: object)
            }

        } else if let collider = object.attachedCollider, collider.isColliding || collider.isOutOfBounds {
            object.collidingVelocity = input
            object.velocity = Vector.zero
        }

        moveRigidBody(object, across: deltaTime)
        object.attachedCollider?.colliderShape.center = object.position
    }

    private func alignEntityRotation(for rigidBody: Rigidbody) {
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
