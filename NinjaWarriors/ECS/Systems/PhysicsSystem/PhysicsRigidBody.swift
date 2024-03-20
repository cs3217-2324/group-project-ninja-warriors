//
//  PhysicsRigidBody.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol PhysicsRigidBody {
    func resultantNormVec(normVec: Vector, src: PhysicsBody, dst: PhysicsBody) -> Vector
    func resultantTanVector(tanVec: Vector, src: PhysicsBody) -> Vector
    func assignResultantVel(normVel: Vector,
                            tanVel: Vector,
                            collider: inout PhysicsBody,
                            collidee: inout PhysicsBody)
}
