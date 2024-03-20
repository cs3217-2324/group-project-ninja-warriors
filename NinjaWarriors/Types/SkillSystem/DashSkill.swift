//
//  DashSkill.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 19/3/24.
//

import Foundation

class DashSkill: MovementSkill {
    var id: SkillID
    var cooldown: Int = 8
    var isOnCooldown: Bool = false

    init(id: SkillID) {
        self.id = id
    }

    func activate() {
        isOnCooldown = true
        print("dash activated")
    }

    // TODO: remove and handle with TransformHandler system
    func performMovement(on target: Entity) {
//        if let player = target as? Player {
//            player.changePosition(to: Point(xCoord: 10, yCoord: 10))
//        }
    }
}
