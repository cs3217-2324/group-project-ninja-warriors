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
    var effectIsActiveInsideShape: Bool

    init(id: ComponentID, entity: EntityWrapper, environmentShape: ShapeWrapper, effectIsActiveInsideShape: Bool) {
        self.id = id
        self.entity = entity
        self.environmentShape = environmentShape
        self.effectIsActiveInsideShape = effectIsActiveInsideShape
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(environmentShape, forKey: AnyCodingKey(stringValue: "environmentShape"))
        try container.encode(effectIsActiveInsideShape, forKey: AnyCodingKey(stringValue: "effectIsActiveInsideShape"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))
        environmentShape = try container.decode(ShapeWrapper.self, forKey: AnyCodingKey(stringValue: "environmentShape"))
        effectIsActiveInsideShape = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "effectIsActiveInsideShape"))
    }

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return EnvironmentEffect(id: id, entity: entity, environmentShape: environmentShape.toShape(), effectIsActiveInsideShape: effectIsActiveInsideShape)
    }
}
