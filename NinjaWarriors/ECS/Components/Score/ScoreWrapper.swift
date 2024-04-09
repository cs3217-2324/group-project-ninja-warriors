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
    var entityGainScoreMap: [EntityID: Bool]

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Score(id: id, entity: entity, score: score, entityGainScoreMap: entityGainScoreMap)
    }
}
