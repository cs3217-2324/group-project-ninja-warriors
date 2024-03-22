//
//  Rigidbody.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

class Rigidbody: Component {
    var angularDrag: Double
    var angularVelocity: Double
    var mass: Double
    var rotation: Double
    var totalForce: Double
    var gravityScale: Double
    var gravity: Double
    var inertia: Double
    var attachedColliderCount: Int
    var collisionDetectionMode: Bool
    var position: Point
    var velocity: Vector
    var attachedColliders: [Collider]

    init(id: EntityID, entity: Entity, angularDrag: Double, angularVelocity: Double, mass: Double,
         rotation: Double, totalForce: Double, gravityScale: Double, gravity: Double, inertia: Double,
         attachedColliderCount: Int, collisionDetectionMode: Bool, position: Point, velocity: Vector,
         attachedColliders: [Collider]) {
        self.angularDrag = angularDrag
        self.angularVelocity = angularVelocity
        self.mass = mass
        self.rotation = rotation
        self.totalForce = totalForce
        self.gravityScale = gravityScale
        self.gravity = gravity
        self.inertia = inertia
        self.attachedColliderCount = attachedColliderCount
        self.collisionDetectionMode = collisionDetectionMode
        self.position = position
        self.velocity = velocity
        self.attachedColliders = attachedColliders

        super.init(id: id, entity: entity)
    }

    func addForce(_ force: Double) {
        totalForce += force
    }

    func addCollider(_ collider: Collider) {
        attachedColliders.append(collider)
    }

    func isAwake() -> Bool {
        collisionDetectionMode
    }

    func isSleeping() -> Bool {
        !collisionDetectionMode
    }

    func sleep() {
        collisionDetectionMode = false
    }

    func wakeUp() {
        collisionDetectionMode = true
    }

    func movePosition(to position: Point) {
        self.position = position
    }

    func moveRotation(to rotation: Double) {
        self.rotation = rotation
    }

    func getShape() -> Shape? {
        entity?.shape
    }

    func minDistancePoint() -> (Double, Point?) {
        var minDistance = Double.greatestFiniteMagnitude
        var closestPoint: Point?
        for collider in attachedColliders {
            let distance = position.distance(to: collider.getPosition())
            if distance < minDistance {
                minDistance = distance
                closestPoint = collider.getPosition()
            }
        }
        return (minDistance, closestPoint)
    }

    func minDistance() -> Double {
        let (minDistance, _) = minDistancePoint()
        return minDistance
    }

    func closestPoint() -> Point? {
        let (_, closestPoint) = minDistancePoint()
        return closestPoint
    }
}
