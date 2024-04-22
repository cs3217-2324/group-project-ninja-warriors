//
//  DestroyTagWrapper.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

struct DestroyTagWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper

    func toComponent(entity: Entity) -> Component? {
        return DestroyTag(id: id, entity: entity)
    }
}
