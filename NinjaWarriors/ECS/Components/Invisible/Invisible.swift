//
//  Invisible.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 19/4/24.
//

import Foundation

class Invisible: Component {

    override init(id: ComponentID, entity: Entity) {
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return InvisibleWrapper(id: id, entity: entityWrapper)
    }
}
