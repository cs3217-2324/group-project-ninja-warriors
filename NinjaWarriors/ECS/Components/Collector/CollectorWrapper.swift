//
//  CollectorWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 19/4/24.
//

import Foundation

struct CollectorWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var entityTypeCounts: [String: Int] = [:]
    var timer: TimeInterval
    var recentEntity: EntityID

    init(id: ComponentID, entity: EntityWrapper, entityTypeCounts: [String: Int],
         timer: TimeInterval, recentEntity: EntityID) {
        self.id = id
        self.entity = entity
        self.entityTypeCounts = entityTypeCounts
        self.timer = timer
        self.recentEntity = recentEntity
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))

        var entityContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                        forKey: AnyCodingKey(stringValue: "entityTypeCounts"))

        for (entityType, count) in entityTypeCounts {
            try entityContainer.encode(count, forKey: AnyCodingKey(stringValue: entityType))
        }

        try container.encode(timer, forKey: AnyCodingKey(stringValue: "timer"))
        try container.encode(recentEntity, forKey: AnyCodingKey(stringValue: "recentEntity"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))

        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))

        do {
            let entityContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                                forKey: AnyCodingKey(stringValue: "entityTypeCounts"))
            for key in entityContainer.allKeys {
                let entityType = key.stringValue
                let count = try entityContainer.decode(Int.self, forKey: key)
                entityTypeCounts[entityType] = count
            }
        } catch {
            entityTypeCounts = [:] // Assign an empty dictionary if field is missing
        }

        timer = try container.decode(TimeInterval.self, forKey: AnyCodingKey(stringValue: "timer"))
        recentEntity = try container.decode(EntityID.self, forKey: AnyCodingKey(stringValue: "recentEntity"))
    }

    func toComponent(entity: Entity) -> Component? {
        return Collector(id: id, entity: entity, entityTypeCounts: entityTypeCounts,
                         timer: timer, recentEntity: recentEntity)
    }
}
