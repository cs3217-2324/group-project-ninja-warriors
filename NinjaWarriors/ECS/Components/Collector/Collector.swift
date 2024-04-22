//
//  Collector.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 19/4/24.
//

import Foundation

class Collector: Component {
    private var entityTypeCounts: [String: Int] = [:]
    private var timer: TimeInterval
    private var recentEntity: EntityID

    init(id: ComponentID, entity: Entity, entityTypeCounts: [String: Int], timer: TimeInterval = 0.0, recentEntity: EntityID = Constants.defaultGemID) {
        self.entityTypeCounts = entityTypeCounts
        self.timer = timer
        self.recentEntity = recentEntity
        super.init(id: id, entity: entity)
    }

    func updateTime(_ time: TimeInterval) {
        timer += time
        if timer >= Constants.gemResetTime {
            timer = Constants.gemRespawnTime
        }
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return CollectorWrapper(id: id, entity: entityWrapper, entityTypeCounts: entityTypeCounts,
                                timer: timer, recentEntity: recentEntity)
    }

    func addItem(of type: String, count: Int, currEntity: EntityID) {
        if timer >= Constants.gemRespawnTime || entityTypeCounts.isEmpty || currEntity != recentEntity {
            if let currentCount = entityTypeCounts[type] {
                entityTypeCounts[type] = currentCount + count
            } else {
                entityTypeCounts[type] = count
            }
            timer = 0.0
            recentEntity = currEntity
        } else if currEntity == recentEntity && timer >= Constants.gemRespawnTime {
            if let currentCount = entityTypeCounts[type] {
                entityTypeCounts[type] = currentCount + count
            } else {
                entityTypeCounts[type] = count
            }
            timer = 0.0
            recentEntity = currEntity
        }
    }

    func removeItem(of type: String, count: Int) {
        guard let currentCount = entityTypeCounts[type] else {
            return
        }

        entityTypeCounts[type] = currentCount - count

        if let newCount = entityTypeCounts[type], newCount <= 0 {
            entityTypeCounts.removeValue(forKey: type)
        }
    }

    func countItem(of type: String) -> Int {
        entityTypeCounts[type] ?? 0
    }
}

