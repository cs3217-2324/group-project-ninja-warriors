//
//  PlayerComponentWrapper.swift
//  NinjaWarriors
//
//  Created by proglab on 14/4/24.
//

import Foundation

struct PlayerComponentWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper

    func toComponent(entity: Entity) -> Component? {
        return PlayerComponent(id: id, entity: entity)
    }
}
