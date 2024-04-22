//
//  Respawnable.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

class Respawnable: Component {
    let respawnTime: TimeInterval

    init(id: ComponentID, entity: Entity, respawnTime: TimeInterval) {
        self.respawnTime = respawnTime
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return RespawnableWrapper(id: id, entity: entityWrapper, respawnTime: respawnTime)
    }
}
