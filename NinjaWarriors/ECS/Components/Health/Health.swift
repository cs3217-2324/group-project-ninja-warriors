//
//  Health.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation

class Health: Component {
    var entityInflictDamageMap: [EntityID: Bool]
    var health: Double
    var maxHealth: Double

    init(id: ComponentID, entity: Entity, entityInflictDamageMap: [EntityID: Bool],
         health: Double, maxHealth: Double) {
        self.entityInflictDamageMap = entityInflictDamageMap
        self.health = health
        self.maxHealth = maxHealth
        super.init(id: id, entity: entity)
    }

    override func updateAttributes(_ newHealth: Component) {
        guard let newHealth = newHealth as? Health else {
            return
        }
        self.entityInflictDamageMap = newHealth.entityInflictDamageMap
        self.health = newHealth.health
        self.maxHealth = newHealth.maxHealth
    }

    override func changeEntity(to entity: Entity) -> Component {
        Health(id: self.id, entity: entity, entityInflictDamageMap: self.entityInflictDamageMap, health: self.health, maxHealth: self.maxHealth)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }

        return HealthWrapper(id: id, entity: entityWrapper, entityInflictDamageMap: entityInflictDamageMap,
                             health: health, maxHealth: maxHealth, wrapperType: NSStringFromClass(type(of: entityWrapper)))
    }
}
