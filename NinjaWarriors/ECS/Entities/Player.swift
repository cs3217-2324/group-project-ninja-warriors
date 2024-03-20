//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    var id: EntityID

    init(id: String) {
        self.id = id
    }

    func getInitializingComponents() -> [Component] {
//        let transform = TransformComponent()
        return []
    }

    // TODO: deprecate this to EntityWrapper
//    func toPlayerWrapper() -> PlayerWrapper {
//        PlayerWrapper(id: id, transform: transform.toTransformWrapper())
//    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
