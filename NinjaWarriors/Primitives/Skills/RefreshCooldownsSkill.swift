//
//  RefreshCooldownsSkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 24/3/24.
//

import Foundation

class RefreshCooldownsSkill: CooldownModifierSkill {
    var id: SkillID
    private var cooldownDuration: TimeInterval
    var cooldownRemaining: TimeInterval

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 30
        self.cooldownRemaining = 30
    }

    func isOnCooldown() -> Bool {
        return cooldownRemaining > 0
    }
    
    func resetCooldown() {
        return
    }

    func decrementCooldown(deltaTime: TimeInterval) {
        cooldownRemaining = max(0, cooldownRemaining - deltaTime)
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
        print("[RefreshSkill] Activated, all skill cooldowns reset except for RefreshSkill")
        modifyCooldowns(entity, in: manager)
        cooldownRemaining = cooldownDuration
    }
    
    func modifyCooldowns(_ entity: Entity, in manager: EntityComponentManager) {
        // Reset the cooldowns of all skills except itself
        if let skillCaster = manager.getComponent(ofType: SkillCaster.self, for: entity) {
            for (skillId, _) in skillCaster.skills where skillId != self.id {
                skillCaster.skills[skillId]?.resetCooldown()
            }
        }
    }
    
}
