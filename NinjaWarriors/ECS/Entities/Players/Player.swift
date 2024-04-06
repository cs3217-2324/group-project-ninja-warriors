//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    let id: EntityID
    var initializePosition: Point = Point(xCoord: 400, yCoord: 400)

    init(id: EntityID) {
        self.id = id
    }

    convenience init(id: EntityID, position: Point) {
        self.init(id: id)
        self.initializePosition = position
    }

    func getInitializingComponents() -> [Component] {
        return []
    }

    func deepCopy() -> Entity {
        Player(id: id)
    }

    func wrapper() -> EntityWrapper? {
        return PlayerWrapper(id: id)
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
