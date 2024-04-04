//
//  Health.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 30/3/24.
//

import Foundation
import SwiftUI
import UIKit

class Health: Component {
    var entityInflictDamageMap: [EntityID: Bool]
    var health: Int
    var maxHealth: Int

    init(id: ComponentID, entity: Entity, entityInflictDamageMap: [EntityID: Bool],
         health: Int, maxHealth: Int) {
        self.entityInflictDamageMap = entityInflictDamageMap
        self.health = health
        self.maxHealth = maxHealth
        super.init(id: id, entity: entity)

    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }

        /*
        if entityInflictDamageMap.isEmpty {
            entityInflictDamageMap = ["1": true]
        }
        */

        return HealthWrapper(id: id, entity: entityWrapper, entityInflictDamageMap: entityInflictDamageMap,
                             health: health, maxHealth: maxHealth)
    }
}
