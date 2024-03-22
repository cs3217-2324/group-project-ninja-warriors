//
//  DashSkill.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 19/3/24.
//

import Foundation

class DashSkill: MovementSkill {
    var id: SkillID

    init(id: SkillID) {
        self.id = id
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
        print("dash activated")
    }

    func isOnCooldown() -> Bool {
        return true
    }

    func decrementCooldown(deltaTime: TimeInterval) {

    }

    func performMovement(on target: Entity) {
        if let player = target as? Player {
            player.changePosition(to: Point(xCoord: 10, yCoord: 10))
        }
    }
}
