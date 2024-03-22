//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    let id: EntityID
    var shape: Shape

    init(id: EntityID, shape: Shape) {
        self.id = id
        self.shape = shape
    }

    func getInitializingComponents() -> [Component] {
        return []
    }

    // TODO: Must remove this and make change based on system instead
    /// *
    func getPosition() -> CGPoint {
        shape.getCenter()
    }

    func changePosition(to center: Point) {
        shape.center = center
    }
    // */

    func wrapper() -> EntityWrapper? {
        return PlayerWrapper(id: id, shape: shape.toShapeWrapper())
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
