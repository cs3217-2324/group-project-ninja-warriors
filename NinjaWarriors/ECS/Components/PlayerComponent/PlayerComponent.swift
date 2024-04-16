//
//  PlayerComponent.swift
//  NinjaWarriors
//
//  Created by proglab on 14/4/24.
//

import Foundation

class PlayerComponent: Component {
    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return PlayerComponentWrapper(id: id, entity: entityWrapper)
    }
}
