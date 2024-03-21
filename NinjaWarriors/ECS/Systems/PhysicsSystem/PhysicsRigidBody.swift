//
//  PhysicsRigidBody.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol PhysicsRigidBody {
    func resultantNormVec(normVec: Vector, src: RigidbodyHandler, dst: RigidbodyHandler) -> Vector
    func resultantTanVector(tanVec: Vector, src: RigidbodyHandler) -> Vector
    func assignResultantVel(normVel: Vector,
                            tanVel: Vector,
                            collider: inout RigidbodyHandler,
                            collidee: inout RigidbodyHandler)
}
