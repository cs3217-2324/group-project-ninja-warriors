//
//  InvisibleWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 19/4/24.
//

import Foundation

struct InvisibleWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper

    func toComponent(entity: Entity) -> Component? {
        return Invisible(id: id, entity: entity)
    }
}
