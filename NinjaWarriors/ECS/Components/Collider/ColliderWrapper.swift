//
//  ColliderWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 22/3/24.
//

import Foundation

struct ColliderWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var colliderShape: ShapeWrapper
    var collidedEntities: Set<EntityID>
    var isColliding: Bool
    var isOutOfBounds: Bool
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, colliderShape: ShapeWrapper,
         collidedEntities: Set<EntityID> = [], isColliding: Bool, isOutOfBounds: Bool) {
        self.id = id
        self.entity = entity
        self.colliderShape = colliderShape
        self.collidedEntities = collidedEntities
        self.isColliding = isColliding
        self.isOutOfBounds = isOutOfBounds
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(colliderShape, forKey: AnyCodingKey(stringValue: "colliderShape"))
        try container.encode(collidedEntities, forKey: AnyCodingKey(stringValue: "collidedEntities"))
        try container.encode(isColliding, forKey: AnyCodingKey(stringValue: "isColliding"))
        try container.encode(isOutOfBounds, forKey: AnyCodingKey(stringValue: "isOutOfBounds"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))
        colliderShape = try container.decode(ShapeWrapper.self, forKey: AnyCodingKey(stringValue: "colliderShape"))

        // Check if collidedEntities field is present
        if container.contains(AnyCodingKey(stringValue: "collidedEntities")) {
            collidedEntities = try container.decode(Set<EntityID>.self, forKey: AnyCodingKey(stringValue: "collidedEntities"))
        } else {
            collidedEntities = Set<EntityID>()
        }
        isColliding = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "isColliding"))
        isOutOfBounds = try container.decode(Bool.self, forKey: AnyCodingKey(stringValue: "isOutOfBounds"))
    }

    func toComponent() -> (Component, Entity)? {
        if let entity = entity as? PlayerWrapper {
            guard let entity = entity.toEntity() else {
                return nil
            }
            return (Collider(id: id, entity: entity, colliderShape: colliderShape.toShape(),
                            collidedEntities: collidedEntities,
                            isColliding: isColliding, isOutOfBounds: isOutOfBounds), entity)
        } else if let entity = entity as? ObstacleWrapper {
            guard let entity = entity.toEntity() else {
                return nil
            }
            return (Collider(id: id, entity: entity, colliderShape: colliderShape.toShape(),
                            collidedEntities: collidedEntities,
                            isColliding: isColliding, isOutOfBounds: isOutOfBounds), entity)
        } else {
            return nil
        }
    }
}
