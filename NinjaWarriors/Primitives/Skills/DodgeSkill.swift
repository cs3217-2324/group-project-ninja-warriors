//
//  DodgeSkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 24/3/24.
//

import Foundation

class DodgeSkill: SelfModifyingSkill {
    var id: SkillID
    private var cooldownDuration: TimeInterval
    private var cooldownRemaining: TimeInterval = 0
    private var invulnerabilityDuration: TimeInterval = 1

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 10
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
    
    func activate(from entity: Entity, in manager: EntityComponentManager) {
        if isOnCooldown() { return }

        modifySelf(entity, in: manager)
        cooldownRemaining = cooldownDuration
    }
    
    func modifySelf(_ entity: Entity, in manager: EntityComponentManager) {
        print("[DodgeSkill] Activated on \(entity), invulnerable for \(invulnerabilityDuration) seconds")
    }
}
