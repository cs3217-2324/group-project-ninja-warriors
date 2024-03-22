//
//  PhysicsRigidBody.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol PhysicsRigidBody {
    func resultantNormVec(normVec: Vector, src: Rigidbody, dst: Rigidbody) -> Vector
    func resultantTanVector(tanVec: Vector, src: Rigidbody) -> Vector
    func assignResultantVel(normVel: Vector, tanVel: Vector,
                            collider: inout Rigidbody, collidee: inout Rigidbody)
}
