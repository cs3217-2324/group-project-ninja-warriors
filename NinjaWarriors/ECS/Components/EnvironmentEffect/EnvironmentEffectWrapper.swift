//
//  EnvironmentEffectWrapper.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 5/4/24.
//

import Foundation

struct EnvironmentEffectWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var environmentShape: ShapeWrapper
    var environmentShapeType: String
    var effectIsActiveInsideShape: Bool

    init(id: ComponentID, entity: EntityWrapper, environmentShape: Shape, effectIsActiveInsideShape: Bool) {
        self.id = id
        self.entity = entity
        self.environmentShape = environmentShape.wrapper()
        self.environmentShapeType = String(describing: type(of: environmentShape))
        self.effectIsActiveInsideShape = effectIsActiveInsideShape
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(environmentShape, forKey: AnyCodingKey(stringValue: "environmentShape"))
        try container.encode(environmentShapeType, forKey: AnyCodingKey(stringValue: "environmentShapeType"))
        try container.encode(effectIsActiveInsideShape, forKey: AnyCodingKey(stringValue: "effectIsActiveInsideShape"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))
        environmentShape = try container.decode(ShapeWrapper.self, forKey: AnyCodingKey(stringValue: "environmentShape"))
        environmentShapeType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "environmentShapeType"))
        effectIsActiveInsideShape = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "effectIsActiveInsideShape"))
    }

    func toComponent(entity: Entity) -> Component? {
        let shape = environmentShape.toShape()
        guard let shapeType = NSClassFromString(Constants.directory + environmentShapeType) as? CircleShape.Type else {
            return EnvironmentEffect(id: id, entity: entity, environmentShape: environmentShape.toShape(), effectIsActiveInsideShape: effectIsActiveInsideShape)
        }
        let circle = shapeType.init(center: shape.center, radius: shape.halfLength)
        return EnvironmentEffect(id: id, entity: entity, environmentShape: circle, effectIsActiveInsideShape: effectIsActiveInsideShape)
    }
}
