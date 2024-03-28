//
//  Rigidbody.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

// https://docs.unity3d.com/ScriptReference/Rigidbody2D.html
class Rigidbody: Component {
    var angularDrag: Double
    var angularVelocity: Double
    var mass: Double
    var rotation: Double
    var totalForce: Vector
    var acceleration: Vector {
        totalForce.scale(1 / mass)
    }
    var inertia: Double
    var position: Point
    var velocity: Vector
    var attachedColliders: [Collider]
    var attachedColliderCount: Int {
        attachedColliders.count
    }

    init(id: EntityID, entity: Entity, angularDrag: Double, angularVelocity: Double, mass: Double,
         rotation: Double, totalForce: Vector, inertia: Double, position: Point, velocity: Vector, attachedColliders: [Collider]) {
        self.angularDrag = angularDrag
        self.angularVelocity = angularVelocity
        self.mass = mass
        self.rotation = rotation
        self.totalForce = totalForce
        self.inertia = inertia
        self.position = position
        self.velocity = velocity
        self.attachedColliders = attachedColliders

        super.init(id: id, entity: entity)
    }

    func addForce(_ force: Vector) {
        totalForce = totalForce.add(vector: force)
    }

    func addCollider(_ collider: Collider) {
        attachedColliders.append(collider)
    }

    func movePosition(by vector: Vector) {
        self.position = position.add(vector: vector)

        print("move vector", vector, "to position", position)

        for collider in attachedColliders {
            collider.movePosition(by: vector)
        }
    }

    func moveRotation(to rotation: Double) {
        self.rotation = rotation
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

    func update(dt deltaTime: TimeInterval) {
        // Update position

        let deltaPosition = velocity.scale(deltaTime * 2).add(vector: acceleration.scale(0.5 * pow(deltaTime, 2)))
        movePosition(by: deltaPosition)

        // Update velocity
        velocity = velocity.add(vector: acceleration.scale(deltaTime))

        // Reset force
        totalForce = Vector.zero
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entity = entity.wrapper() else {
            return nil
        }
        var wrapColliders: [ColliderWrapper] = []

        for collider in attachedColliders {
            if let colliderWrap = collider.wrapper() as? ColliderWrapper {
                wrapColliders.append(colliderWrap)
            }
        }
        return RigidbodyWrapper(id: id, entity: entity, angularDrag: angularDrag,
                                angularVelocity: angularVelocity, mass: mass,
                                rotation: rotation, totalForce: totalForce.toVectorWrapper(),
                                inertia: inertia, position: position.toPointWrapper(),
                                velocity: velocity.toVectorWrapper(), attachedColliders: wrapColliders)

    }
}
