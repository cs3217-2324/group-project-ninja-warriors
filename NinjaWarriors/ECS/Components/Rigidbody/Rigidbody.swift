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
    
    override func updateAttributes(_ newRigidbody: Component) {
        guard let newRigidbody = newRigidbody as? Rigidbody else {
            return
        }
        print("updating!!", self.position.xCoord, newRigidbody.position.xCoord)
        self.angularDrag = newRigidbody.angularDrag
        self.angularVelocity = newRigidbody.angularVelocity
        self.mass = newRigidbody.mass
        self.rotation = newRigidbody.rotation
        self.totalForce = newRigidbody.totalForce
        self.inertia = newRigidbody.inertia
        self.position.updateAttributes(newRigidbody.position)
        self.offset.updateAttributes(newRigidbody.offset)
        self.velocity = newRigidbody.velocity
        self.collidingVelocity = newRigidbody.collidingVelocity

        guard let newAttachedCollider = newRigidbody.attachedCollider else {
            return
        }
        self.attachedCollider?.updateAttributes(newAttachedCollider)
    }

    override func changeEntity(to entity: Entity) -> Component {
        Rigidbody(id: self.id, entity: entity, angularDrag: self.angularDrag,
                  angularVelocity: self.angularVelocity, mass: self.mass, rotation: self.rotation,
                  totalForce: self.totalForce, inertia: self.inertia, position: self.position,
                  offset: self.offset, velocity: self.velocity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entity = entity.wrapper() else {
            return nil
        }

        if let colliderWrap = attachedCollider?.wrapper() as? ColliderWrapper {
            return RigidbodyWrapper(id: id, entity: entity, angularDrag: angularDrag,
                                    angularVelocity: angularVelocity, mass: mass,
                                    rotation: rotation, totalForce: totalForce.wrapper(),
                                    inertia: inertia, position: position.wrapper(),
                                    offset: offset.wrapper(), velocity: velocity.wrapper(),
                                    attachedCollider: colliderWrap,
                                    wrapperType: NSStringFromClass(type(of: entity)))
        } else {
            return nil
        }
    }
}
