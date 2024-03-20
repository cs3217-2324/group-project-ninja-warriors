//
//  TransformHandler.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 20/3/24.
//

import Foundation

// TODO: Only add entities with shape to manager, do not add all entities
class TransformHandler: System {
    var manager: EntityComponentManager?

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    // TODO: Obey law of demeter
    func update(after time: TimeInterval, entityId: String, field: Any?) {
        guard let entity = manager?.entityMap[entityId] else {
            return
        }
        guard let center = field as? Point else {
            return
        }
        entity.shape.center = center
    }
}
