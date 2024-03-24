//
//  Collider.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

// https://docs.unity3d.com/ScriptReference/Collider2D.html
class Collider: Component {
    var colliderShape: Shape
    var bounciness: Double
    var density: Double
    var restitution: Double
    var isColliding: Bool
    var offset: Vector

    init(id: EntityID, entity: Entity, colliderShape: Shape, bounciness: Double,
         density: Double, restitution: Double, isColliding: Bool,
         offset: Vector) {
        self.colliderShape = colliderShape
        self.bounciness = bounciness
        self.density = density
        self.restitution = restitution
        self.isColliding = isColliding
        self.offset = offset

        super.init(id: id, entity: entity)
    }

    func movePosition(by vector: Vector) {
        colliderShape.center = colliderShape.center.add(vector: vector)
    }

    func getPosition() -> Point {
        colliderShape.center.add(vector: offset)
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

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return ColliderWrapper(id: id, entity: entityWrapper,
                               colliderShape: colliderShape.toShapeWrapper(),
                               bounciness: bounciness, density: density,
                               restitution: restitution, isColliding: isColliding,
                               offset: offset.toVectorWrapper())
    }
}
