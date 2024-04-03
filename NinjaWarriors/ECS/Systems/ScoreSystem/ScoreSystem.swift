//
//  ScoreSystem.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 1/4/24.
//

import Foundation

class ScoreSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let healthScoreMap = createHealthScoreMap()

        updateScore(for: healthScoreMap)
    }

    func createHealthScoreMap() -> [Health: Score] {
        var healthScoreMap: [Health: Score] = [:]

        /*
        let healthComponents = manager.getAllComponents(ofType: Health.self)
        let scoreComponents = manager.getAllComponents(ofType: Score.self)

        for healthComponent in healthComponents {
            for scoreComponent in scoreComponents {
                if healthComponent.entity.id == scoreComponent.entity.id {
                    healthScoreMap[healthComponent] = scoreComponent
                }
            }
        }
        */
        return healthScoreMap
    }

    func updateScore(for healthScoreMap: [Health: Score]) {
        for (health, score) in healthScoreMap {
            for (entity, status) in health.entityInflictDamageMap where status == true {
                if score.entityGainScoreMap[entity] == nil {
                    score.entityGainScoreMap[entity] = true
                    score.score += 10
                    print("increase score: \(score.score) / 100")
                } else if let scoreStatus = score.entityGainScoreMap[entity], !scoreStatus {
                    score.entityGainScoreMap[entity] = true
                    score.score += 10
                    print("increase score: \(score.score) / 100")
                }
            }
        }
    }
    // TODO: Remove entities not colliding in entityGainScoreMap
}
