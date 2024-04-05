//
//  RigidbodyWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

struct RigidbodyWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var angularDrag: Double
    var angularVelocity: Double
    var mass: Double
    var rotation: Double
    var totalForce: VectorWrapper
    var inertia: Double
    var position: PointWrapper
    var offset: PointWrapper
    var velocity: VectorWrapper
    var attachedCollider: ColliderWrapper
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, angularDrag: Double, angularVelocity: Double, mass: Double, rotation: Double, totalForce: VectorWrapper, inertia: Double, position: PointWrapper, offset: PointWrapper, velocity: VectorWrapper, attachedCollider: ColliderWrapper, wrapperType: String) {
        self.id = id
        self.entity = entity
        self.angularDrag = angularDrag
        self.angularVelocity = angularVelocity
        self.mass = mass
        self.rotation = rotation
        self.totalForce = totalForce
        self.inertia = inertia
        self.position = position
        self.offset = offset
        self.velocity = velocity
        self.attachedCollider = attachedCollider
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(angularDrag, forKey: AnyCodingKey(stringValue: "angularDrag"))
        try container.encode(angularVelocity, forKey: AnyCodingKey(stringValue: "angularVelocity"))
        try container.encode(mass, forKey: AnyCodingKey(stringValue: "mass"))
        try container.encode(rotation, forKey: AnyCodingKey(stringValue: "rotation"))
        try container.encode(totalForce, forKey: AnyCodingKey(stringValue: "totalForce"))
        try container.encode(inertia, forKey: AnyCodingKey(stringValue: "inertia"))
        try container.encode(position, forKey: AnyCodingKey(stringValue: "position"))
        try container.encode(offset, forKey: AnyCodingKey(stringValue: "offset"))
        try container.encode(velocity, forKey: AnyCodingKey(stringValue: "velocity"))
        try container.encode(attachedCollider, forKey: AnyCodingKey(stringValue: "attachedCollider"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))

        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }
        
        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))
        angularDrag = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "angularDrag"))
        angularVelocity = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "angularVelocity"))
        mass = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "mass"))
        rotation = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "rotation"))
        totalForce = try container.decode(VectorWrapper.self, forKey: AnyCodingKey(stringValue: "totalForce"))
        inertia = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "inertia"))
        position = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "position"))
        offset = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "offset"))
        velocity = try container.decode(VectorWrapper.self, forKey: AnyCodingKey(stringValue: "velocity"))
        attachedCollider = try container.decode(ColliderWrapper.self, forKey: AnyCodingKey(stringValue: "attachedCollider"))
    }

    // TODO: TBC on colliderEntityUnwrap.0
    func toComponent(entity: Entity) -> Component? {
        if let colliderUnwrap = attachedCollider.toComponent(entity: entity) as? Collider {
            return Rigidbody(id: id, entity: entity, angularDrag: angularDrag,
                             angularVelocity: angularVelocity, mass: mass, rotation: rotation,
                             totalForce: totalForce.toVector(), inertia: inertia, position: position.toPoint(),
                             offset: offset.toPoint(), velocity: velocity.toVector(),
                              attachedCollider: colliderUnwrap)
        } else {
            return nil
        }
    }
}
