//
//  Collider.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

class Collider {
    unowned var attachedRigidBody: Rigidbody
    var colliderShape: Shape
    var bounciness: Double
    var density: Double
    var restitution: Double
    var shapeCount: Int
    var isColliding: Bool
    var offset: Vector
    var bounds: [Line]

    init(attachedRigidBody: Rigidbody, colliderShape: Shape, bounciness: Double,
         density: Double, restitution: Double, shapeCount: Int, isColliding: Bool,
         offset: Vector, bounds: [Line]) {
        self.attachedRigidBody = attachedRigidBody
        self.colliderShape = colliderShape
        self.bounciness = bounciness
        self.density = density
        self.restitution = restitution
        self.shapeCount = shapeCount
        self.isColliding = isColliding
        self.offset = offset
        self.bounds = bounds
    }

    func getPosition() -> Point {
        attachedRigidBody.position.add(vector: offset)
    }

    func distanceTo(collider: Collider) -> Double {
        self.getPosition().distance(to: collider.getPosition())
    }

    func addBounce(by bounce: Double) {
        bounciness += bounce
    }

    func addDensity(by density: Double) {
        self.density += density
    }

    func addRestitution(by restitution: Double) {
        self.restitution += restitution
    }

    func addOffset(by vector: Vector) {
        self.offset = self.offset.add(vector: vector)
    }

    func setCollide(to status: Bool) {
        isColliding = status
    }
}
