//
//  DashSkill.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 19/3/24.
//

import Foundation

class DashSkill: MovementSkill {
    var id: SkillID
    private var cooldownDuration: TimeInterval // Cooldown duration in seconds
    private var cooldownRemaining: TimeInterval = 0 // Time remaining on cooldown

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
        performMovement(on: entity, in: manager)
        cooldownRemaining = cooldownDuration
    }

    func isOnCooldown() -> Bool {
        return cooldownRemaining > 0
    }

    func decrementCooldown(deltaTime: TimeInterval) {
        cooldownRemaining = max(0, cooldownRemaining - deltaTime)
    }
    
    func resetCooldown() {
        cooldownRemaining = 0
    }

    func performMovement(on target: Entity, in manager: EntityComponentManager) {
        print("[DashSkill] Activated on \(target)")
        let currCenter = target.shape.getCenter()

        target.shape.center.setCartesian(xCoord: currCenter.x, yCoord: currCenter.y + 100)

    }
}
