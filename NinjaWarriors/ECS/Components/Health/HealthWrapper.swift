//
//  HealthWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

struct HealthWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var entityInflictDamageMap: [EntityID: Bool]
    var health: Int
    var maxHealth: Int

    func toComponent() -> Component? {
        guard let entity = entity.toEntity() else {
            return nil
        }
        return Health(id: id, entity: entity, entityInflictDamageMap: entityInflictDamageMap,
                      health: health, maxHealth: maxHealth)
    }
}
