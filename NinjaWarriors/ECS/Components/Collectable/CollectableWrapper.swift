//
//  CollectableWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 19/4/24.
//

import Foundation

struct CollectableWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var entityType: String

    func toComponent(entity: Entity) -> Component? {
        return Collectable(id: id, entity: entity, entityType: entityType)
    }
}
