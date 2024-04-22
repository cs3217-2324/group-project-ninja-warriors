//
//  RespawnableWrapper.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

struct RespawnableWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var respawnTime: TimeInterval

    func toComponent(entity: Entity) -> Component? {
        return Respawnable(id: id, entity: entity, respawnTime: respawnTime)
    }
}
