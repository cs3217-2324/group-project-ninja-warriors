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
    var totalForce: Vector
    var acceleration: Vector {
        totalForce.scale(1 / mass)
    }
    var inertia: Double
    var position: Point
    var offset: Point
    var velocity: Vector
    var collidingVelocity: Vector?
    var attachedCollider: Collider?

    init(id: ComponentID, entity: Entity, angularDrag: Double, angularVelocity: Double, mass: Double,
         rotation: Double, totalForce: Vector, inertia: Double, position: Point, velocity: Vector, attachedCollider: Collider? = nil) {
        self.angularDrag = angularDrag
        self.angularVelocity = angularVelocity
        self.mass = mass
        self.rotation = rotation
        self.totalForce = totalForce
        self.inertia = inertia
        self.position = position
        self.offset = position
        self.velocity = velocity
        self.attachedCollider = attachedCollider

        super.init(id: id, entity: entity)
    }

    init(id: ComponentID, entity: Entity, angularDrag: Double, angularVelocity: Double, mass: Double,
         rotation: Double, totalForce: Vector, inertia: Double, position: Point, offset: Point,
         velocity: Vector, attachedCollider: Collider? = nil) {
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
        self.attachedCollider = attachedCollider

        super.init(id: id, entity: entity)
    }

    func addForce(_ force: Vector) {
        totalForce = totalForce.add(vector: force)
    }

    func addCollider(_ collider: Collider) {
        attachedCollider = collider
    }

    func movePosition(by vector: Vector) {
        if collidingVelocity == nil {
            self.position = position.add(vector: vector)
        }
        guard let attachedCollider = attachedCollider else {
            return
        }
        attachedCollider.movePosition(by: vector)
    }

    func moveRotation(to rotation: Double) {
        self.rotation = rotation
    }

    func update(dt deltaTime: TimeInterval) {
        // Determine the velocity to use for calculations
        var currentVelocity = collidingVelocity ?? velocity

        // Update position
        let deltaPosition = currentVelocity.scale(deltaTime).add(vector: acceleration.scale(0.5 * pow(deltaTime, 2)))
        movePosition(by: deltaPosition)

        // Update velocity
        currentVelocity = currentVelocity.add(vector: acceleration.scale(deltaTime))
        if collidingVelocity != nil {
            self.collidingVelocity = currentVelocity
        } else {
            velocity = currentVelocity
        }

        // Reset force
        totalForce = Vector.zero
    }

    func deepCopy() -> Rigidbody {
        if let attachedCollider = attachedCollider {
            return Rigidbody(id: id, entity: entity, angularDrag: angularDrag, angularVelocity: angularVelocity,
                             mass: mass, rotation: rotation, totalForce: totalForce, inertia: inertia,
                             position: position, offset: offset, velocity: velocity,
                             attachedCollider: attachedCollider.deepCopy())
        } else {
            return Rigidbody(id: id, entity: entity, angularDrag: angularDrag, angularVelocity: angularVelocity,
                             mass: mass, rotation: rotation, totalForce: totalForce, inertia: inertia,
                             position: position, offset: offset, velocity: velocity)
        }

    }

    override func wrapper() -> ComponentWrapper? {
        print("check entity", entity.id)
        guard let entity = entity.wrapper() else {
            return nil
        }

        if let colliderWrap = attachedCollider?.wrapper() as? ColliderWrapper {
            return RigidbodyWrapper(id: id, entity: entity, angularDrag: angularDrag,
                                    angularVelocity: angularVelocity, mass: mass,
                                    rotation: rotation, totalForce: totalForce.wrapper(),
                                    inertia: inertia, position: position.wrapper(),
                                    offset: offset.wrapper(), velocity: velocity.wrapper(), attachedCollider: colliderWrap)
        } else {
            return nil
        }
    }
}
