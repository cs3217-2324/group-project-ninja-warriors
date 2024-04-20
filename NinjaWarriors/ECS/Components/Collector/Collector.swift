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
}
