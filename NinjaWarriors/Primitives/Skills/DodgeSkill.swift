//
//  DodgeSkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 24/3/24.
//

import Foundation

class DodgeSkill: SelfModifyingSkill {
    var id: SkillID
    var cooldownDuration: TimeInterval
    private var invulnerabilityDuration: TimeInterval = 1

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }
    
    func activate(from entity: Entity, in manager: EntityComponentManager) {
        modifySelf(entity, in: manager)
    }
    
    func modifySelf(_ entity: Entity, in manager: EntityComponentManager) {
        print("[DodgeSkill] Activated on \(entity), invulnerable for \(invulnerabilityDuration) seconds")
    }
    
    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "DodgeSkill", cooldownDuration: cooldownDuration)
    }
}
