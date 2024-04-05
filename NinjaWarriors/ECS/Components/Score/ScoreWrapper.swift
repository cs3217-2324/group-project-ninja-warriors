//
//  ScoreWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 1/4/24.
//

import Foundation

struct ScoreWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var score: Int
    var entityGainScoreMap: [EntityID: Bool] = [:]
    var wrapperType: String

    init(id: ComponentID, entity: EntityWrapper, score: Int,
         entityGainScoreMap: [EntityID: Bool], wrapperType: String) {
        self.id = id
        self.entity = entity
        self.score = score
        self.entityGainScoreMap = entityGainScoreMap
        self.wrapperType = wrapperType
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))
        try container.encode(wrapperType, forKey: AnyCodingKey(stringValue: "wrapperType"))

        var entityContainer = container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                        forKey: AnyCodingKey(stringValue: "entityGainScoreMap"))

        for (entityID, hasScore) in entityGainScoreMap {
            try entityContainer.encode(hasScore, forKey: AnyCodingKey(stringValue: entityID))
        }
        try container.encode(score, forKey: AnyCodingKey(stringValue: "score"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(ComponentID.self, forKey: AnyCodingKey(stringValue: "id"))
        wrapperType = try container.decode(String.self, forKey: AnyCodingKey(stringValue: "wrapperType"))

        guard let wrapperClass = NSClassFromString(wrapperType) as? EntityWrapper.Type else {
            throw NSError(domain: "NinjaWarriors.Wrapper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid wrapper type: \(wrapperType)"])
        }

        entity = try container.decode(wrapperClass.self, forKey: AnyCodingKey(stringValue: "entity"))
        score = try container.decode(Int.self, forKey: AnyCodingKey(stringValue: "score"))

        do {
            let entityContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                                forKey: AnyCodingKey(stringValue: "entityGainScoreMap"))
            for key in entityContainer.allKeys {
                let entityID = key.stringValue
                let hasScore = try entityContainer.decode(Bool.self, forKey: key)
                entityGainScoreMap[entityID] = hasScore
            }
        } catch {
            entityGainScoreMap = [:] // Assign an empty dictionary if field is missing
        }
    }

    func toComponent() -> (Component, Entity)? {
        guard let entity = entity as? PlayerWrapper ?? entity as? ObstacleWrapper, let unwrappedEntity = entity.toEntity() else {
            return nil
        }
        return (Score(id: id, entity: unwrappedEntity, score: score, entityGainScoreMap: entityGainScoreMap), unwrappedEntity)
    }
}
