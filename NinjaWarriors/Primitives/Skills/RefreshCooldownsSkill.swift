//
//  RefreshCooldownsSkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 24/3/24.
//

import Foundation

class RefreshCooldownsSkill: CooldownModifierSkill {
    var id: SkillID
    var cooldownDuration: TimeInterval

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
        print("[RefreshSkill] Activated, all skill cooldowns reset except for RefreshSkill")
        modifyCooldowns(entity, in: manager)
    }

    func updateAttributes(_ newRefreshCooldownsSkill: RefreshCooldownsSkill) {
        self.id = newRefreshCooldownsSkill.id
        self.cooldownDuration = newRefreshCooldownsSkill.cooldownDuration
    }
    
    func modifyCooldowns(_ entity: Entity, in manager: EntityComponentManager) {
        // Reset the cooldowns of all skills except itself
        if let skillCaster = manager.getComponent(ofType: SkillCaster.self, for: entity) {
            for (skillId, _) in skillCaster.skills where skillId != self.id {
                skillCaster.resetSkillCooldown(skillId: skillId)
            }
        }
    }
    
    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "RefreshCooldownsSkill", cooldownDuration: cooldownDuration)
    }
}
