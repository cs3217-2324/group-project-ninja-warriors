//
//  SlashAOESkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 23/3/24.
//

import Foundation
class SlashAOESkill: EntitySpawnerSkill {
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
       _ = spawnEntity(from: entity, in: manager)
    }

    func updateAttributes(_ newSlashAOESkill: SlashAOESkill) {
        self.id = newSlashAOESkill.id
        self.cooldownDuration = newSlashAOESkill.cooldownDuration
    }

    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity {
        print("[SlashAOESkill] Activated by \(casterEntity)")
        let slashAOE = SlashAOE(id: RandomNonce().randomNonceString(), casterEntity: casterEntity)
        manager.add(entity: slashAOE, isAdded: false)
        return slashAOE
    }
    
    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "SlashAOESkill", cooldownDuration: cooldownDuration)
    }
}
