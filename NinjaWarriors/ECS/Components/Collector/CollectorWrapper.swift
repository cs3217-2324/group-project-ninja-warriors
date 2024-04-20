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
    var entityTypeCounts: [String: Int]

    func toComponent(entity: Entity) -> Component? {
        return Collector(id: id, entity: entity, entityTypeCounts: entityTypeCounts)
    }
}
