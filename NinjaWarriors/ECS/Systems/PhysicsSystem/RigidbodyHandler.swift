//
//  RigidbodyHandler.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

class RigidbodyHandler: System, PhysicsRigidBody, PhysicsElasticCollision {
    var manager: EntityComponentManager?

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        // print("[RigidbodyHandler] componentMap:", manager?.componentMap)
        guard let componentMap = manager?.componentMap else {
            return
        }
        for (_, component) in componentMap {
            // TODO: Fix this
            if let rigidbody = component as? Rigidbody {
                rigidbody.position = rigidbody.position.add(vector: rigidbody.velocity)
                let gravitationalForce = rigidbody.gravity * rigidbody.gravityScale
                let acceleration = gravitationalForce / rigidbody.mass
                rigidbody.velocity = rigidbody.velocity.add(acceleration)
                rigidbody.position = rigidbody.position.add(vector: rigidbody.velocity)
                // print("[RigidbodyHandler] rigid position update: ", rigidbody.position)
            }
        }
    }

    private func getRigidBodies() -> [Rigidbody] {
        var rigidbody: [Rigidbody] = []
        guard let entityMap = manager?.entityMap else {
            return []
        }
        for (entityId, _) in entityMap {
            guard let componentIdSet = manager?.entityComponentMap[entityId] else { return [] }

            for componentId in componentIdSet {
                if let component = manager?.componentMap[componentId] as? Rigidbody {
                    rigidbody.append(component)
                }
            }
        }
        return rigidbody
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
        // TODO: Check if damp velocity is needed
        // collider.velocity = collider.velocity.add(vector: dampVelocity)
    }

    func doElasticCollision(collider: inout Rigidbody, collidee: inout Rigidbody) {
        guard !collider.mass.isZero && !collidee.mass.isZero else {
            return
        }
        guard let unitNormVec = getUnitNormVector(from: collider.position.convertToVector(), to: collidee.position.convertToVector()) else {
            return
        }
        let unitTanVec = getTangentVector(from: unitNormVec)
        assignResultantVel(normVel: unitNormVec, tanVel: unitTanVec, collider: &collider, collidee: &collidee)
    }
}
