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

    // Update function after a given time interval.
    func update(after time: TimeInterval) {
        handleElasticCollisions()
        moveRigidBodies(with: time)
    }

    // Handle elastic collisions between colliding rigid bodies
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
                // doElasticCollision(collider: &rigidBody, collidee: &otherRigidBody)
            }
        }
    }

    // Move all rigid bodies according to their current velocities
    private func moveRigidBodies(with deltaTime: TimeInterval) {
        let rigidBodies = manager.getAllComponents(ofType: Rigidbody.self)

        for rigidBody in rigidBodies {
            let collider = rigidBody.attachedCollider

            guard let gameControl = gameControl,
                  let gameControlEntity = gameControl.entity else {
                continue
            }

            if !collider.isColliding && rigidBody.entity.id == gameControlEntity.id  {
                rigidBody.velocity = gameControl.getInput()
                rigidBody.collidingVelocity = nil
            } else if collider.isColliding && rigidBody.entity.id == gameControlEntity.id {
                rigidBody.collidingVelocity = gameControl.getInput()
            }

            rigidBody.update(dt: deltaTime)
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
