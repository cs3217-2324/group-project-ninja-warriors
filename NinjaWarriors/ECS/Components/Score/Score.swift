//
//  Score.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 1/4/24.
//

import Foundation

class Score: Component {
    var score: Int
    var entityGainScoreMap: [EntityID: Bool]

    init(id: ComponentID, entity: Entity, score: Int, entityGainScoreMap: [EntityID: Bool]) {
        self.score = score
        self.entityGainScoreMap = entityGainScoreMap
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }

        /*
        if entityGainScoreMap.isEmpty {
            entityGainScoreMap = ["1": true]
        }
        */

        return ScoreWrapper(id: id, entity: entityWrapper, score: score, entityGainScoreMap: entityGainScoreMap)
    }
}
