//
//  RigidbodyHandler.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

class RigidbodyHandler: System, PhysicsRigidBody, PhysicsElasticCollision {
    var manager: EntityComponentManager
    var gameControl: GameControl?

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    convenience init(for manager: EntityComponentManager, with gameControl: GameControl) {
        self.init(for: manager)
        self.gameControl = gameControl
    }

    func update(after time: TimeInterval) {
        //handleElasticCollisions()
        moveRigidBodies(with: time)
        syncTransform()
    }

    private func handleElasticCollisions() {
        let colliders = manager.getAllComponents(ofType: Collider.self)
        for collider in colliders where collider.isColliding {
            guard var rigidBody = manager.getComponent(ofType: Rigidbody.self, for: collider.entity) else {
                return
            }
            for collidedEntityID in collider.collidedEntities {
                guard let otherEntity = manager.entity(with: collidedEntityID),
                      var otherRigidBody = manager.getComponent(ofType: Rigidbody.self, for: otherEntity) else {
                    return
                }
                // Not fully implemented yet
                doElasticCollision(collider: &rigidBody, collidee: &otherRigidBody)
            }
        }
    }

    // Move all rigid bodies according to their current velocities
    private func moveRigidBodies(with deltaTime: TimeInterval) {
        let rigidBodies = manager.getAllComponents(ofType: Rigidbody.self)

        for rigidBody in rigidBodies {
            let collider = rigidBody.attachedCollider

            guard let collider = collider else {
                continue
            }

            var playerInput: Vector = getPlayerInput(for: rigidBody)

            if !collider.isColliding && !collider.isOutOfBounds {
                rigidBody.velocity = playerInput
                if (playerInput.horizontal != 0 || playerInput.vertical != 0) {
                    alignEntityRotation(for: rigidBody, playerInput)
                }
                rigidBody.collidingVelocity = nil

            } else if (collider.isColliding || collider.isOutOfBounds) {
                rigidBody.collidingVelocity = playerInput
                rigidBody.velocity = Vector.zero
            }

            moveRigidBody(rigidBody, across: deltaTime)

            manager.getComponent(ofType: Collider.self, for: rigidBody.entity)?
                .colliderShape.center = rigidBody.position
        }
    }

    private func getPlayerInput(for rigidBody: Rigidbody) -> Vector {
        if rigidBody.angularVelocity == Vector.zero {
            guard let gameControl = gameControl,
                  let gameControlEntity = gameControl.entity,
                  rigidBody.entity.id == gameControlEntity.id else {
                return Vector.zero
            }
            return gameControl.getInput()
        } else {
            return rigidBody.angularVelocity
        }
    }

    private func alignEntityRotation(for rigidBody: Rigidbody, _ input: Vector) {
        let radians = atan2(input.vertical, input.horizontal)

        let degrees = radians * 180 / .pi

        rigidBody.rotation = degrees
    }


    private func moveRigidBody(_ rigidBody: Rigidbody, across deltaTime: TimeInterval) {
        // Determine the velocity to use for calculations
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

    private func syncTransform() {
        let rigidBodies = manager.getAllComponents(ofType: Rigidbody.self)
        for rigidBody in rigidBodies {
            if let transform = manager.getComponent(ofType: Transform.self, for: rigidBody.entity) {
                transform.position = rigidBody.position
            }
        }
    }

    private func getUnitNormVector(from: Vector, to: Vector) -> Vector? {
        let normalVector: Vector = to.subtract(vector: from)
        return normalVector.calcUnitVector()
    }

    private func getTangentVector(from: Vector) -> Vector {
        Vector(horizontal: -from.vertical, vertical: from.horizontal)
    }

    private func getProjection(vector: Vector, velocity: Vector) -> Double {
        vector.dotProduct(with: velocity)
    }

    internal func resultantNormVec(normVec: Vector, src: Rigidbody, dst: Rigidbody) -> Vector {
        let srcVelProj = getProjection(vector: normVec, velocity: src.velocity)
        let dstVelProj = getProjection(vector: normVec, velocity: dst.velocity)

        let kineticConservation = srcVelProj * (src.mass - dst.mass) + 2.0 * dst.mass * dstVelProj
        let momentumConservation = src.mass + dst.mass
        return normVec.scale(kineticConservation / momentumConservation)
    }

    internal func resultantTanVector(tanVec: Vector, src: Rigidbody) -> Vector {
        let srcVelProj = getProjection(vector: tanVec, velocity: src.velocity)
        return tanVec.scale(srcVelProj)
    }

    internal func assignResultantVel(normVel: Vector, tanVel: Vector,
                                     collider: inout Rigidbody, collidee: inout Rigidbody) {
        let resultantNormVel = resultantNormVec(normVec: normVel, src: collider, dst: collidee)
        let resultantTanVel = resultantTanVector(tanVec: tanVel, src: collider)
        collider.velocity = resultantNormVel.add(vector: resultantTanVel)
        collidee.velocity = collider.velocity.getComplement()
        collider.velocity = collider.velocity.scale(1)
    }

    internal func calculateReflectedVelocity(velocity: Vector, collisionNormal: Vector) -> Vector {
        let velocityMagnitude = velocity.getLength()
        let normal = collisionNormal.normalize()

        let velocityProjection = velocity.dotProduct(with: normal)
        let velocityProjectionVector = normal.scale(velocityProjection)

        let reflectedVelocity = velocity.subtract(vector: velocityProjectionVector.scale(2))

        return reflectedVelocity.scale(velocityMagnitude)
    }

    func doElasticCollision(collider: inout Rigidbody, collidee: inout Rigidbody) {
        guard !collider.mass.isZero && !collidee.mass.isZero else {
            return
        }
        guard let unitNormVec = getUnitNormVector(from: collider.position.convertToVector(),
                                                  to: collidee.position.convertToVector()) else {
            return
        }
        let unitTanVec = getTangentVector(from: unitNormVec)
        assignResultantVel(normVel: unitNormVec, tanVel: unitTanVec, collider: &collider, collidee: &collidee)
    }
}
