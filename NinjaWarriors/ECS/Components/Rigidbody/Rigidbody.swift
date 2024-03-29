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
    var offset: Point
    var velocity: Vector
    var collidingVelocity: Vector?
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
        self.offset = position
        self.velocity = velocity
        self.attachedColliders = attachedColliders

        super.init(id: id, entity: entity)
    }

    init(id: EntityID, entity: Entity, angularDrag: Double, angularVelocity: Double, mass: Double,
         rotation: Double, totalForce: Vector, inertia: Double, position: Point, offset: Point,
         velocity: Vector, attachedColliders: [Collider]) {
        self.angularDrag = angularDrag
        self.angularVelocity = angularVelocity
        self.mass = mass
        self.rotation = rotation
        self.totalForce = totalForce
        self.inertia = inertia
        self.position = position
        self.offset = offset
        self.offset = position
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
        if collidingVelocity == nil {
            self.position = position.add(vector: vector)
        }
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

        if var collidingVelocity = collidingVelocity {
            // Update position
            let deltaPosition = collidingVelocity.scale(deltaTime).add(vector: acceleration.scale(0.5 * pow(deltaTime, 2)))
            movePosition(by: deltaPosition)

            collidingVelocity = collidingVelocity.add(vector: acceleration.scale(deltaTime))
            self.collidingVelocity = collidingVelocity

            // Update velocity
            //collidingVelocity = collidingVelocity.add(vector: acceleration.scale(deltaTime))

            // Reset force
            totalForce = Vector.zero
        } else {
            // Update position
            let deltaPosition = velocity.scale(deltaTime).add(vector: acceleration.scale(0.5 * pow(deltaTime, 2)))
            movePosition(by: deltaPosition)

            // Update velocity
            velocity = velocity.add(vector: acceleration.scale(deltaTime))

            // Reset force
            totalForce = Vector.zero
        }
    }

    func deepCopyColliders() -> [Collider] {
        var deepCopyColliders: [Collider] = []
        for collider in attachedColliders {
            deepCopyColliders.append(collider.deepCopy())
        }
        return deepCopyColliders
    }

    func deepCopy() -> Rigidbody {
        return Rigidbody(id: id, entity: entity, angularDrag: angularDrag, angularVelocity: angularVelocity,
                         mass: mass, rotation: rotation, totalForce: totalForce, inertia: inertia,
                         position: position, offset: offset, velocity: velocity,
                         attachedColliders: deepCopyColliders())

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
                                offset: offset.toPointWrapper(), velocity: velocity.toVectorWrapper(), attachedColliders: wrapColliders)
    }
}
