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

    init(id: ComponentID, entity: EntityWrapper, score: Int, entityGainScoreMap: [EntityID: Bool]) {
        self.id = id
        self.entity = entity
        self.score = score
        self.entityGainScoreMap = entityGainScoreMap
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(stringValue: "id"))
        try container.encode(entity, forKey: AnyCodingKey(stringValue: "entity"))

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
        entity = try container.decode(EntityWrapper.self, forKey: AnyCodingKey(stringValue: "entity"))
        score = try container.decode(Int.self, forKey: AnyCodingKey(stringValue: "score"))

        let entityContainer = try container.nestedContainer(keyedBy: AnyCodingKey.self,
                                                            forKey: AnyCodingKey(stringValue: "entityGainScoreMap"))

        for key in entityContainer.allKeys {
            let entityID = key.stringValue
            let hasScore = try entityContainer.decode(Bool.self, forKey: key)
            entityGainScoreMap[entityID] = hasScore
        }
    }

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Score(id: id, entity: entity, score: score, entityGainScoreMap: entityGainScoreMap)
    }
}
