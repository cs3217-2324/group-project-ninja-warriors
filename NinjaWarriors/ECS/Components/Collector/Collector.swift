//
//  Collector.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 19/4/24.
//

import Foundation

class Collector: Component {
    private var entityTypeCounts: [String: Int] = [:]

    init(id: ComponentID, entity: Entity, entityTypeCounts: [String: Int]) {
        self.entityTypeCounts = entityTypeCounts
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return CollectorWrapper(id: id, entity: entityWrapper, entityTypeCounts: entityTypeCounts)
    }

    func addItem(of type: String, count: Int) {
        if let currentCount = entityTypeCounts[type] {
            entityTypeCounts[type] = currentCount + count
        } else {
            entityTypeCounts[type] = count
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
