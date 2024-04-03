//
//  SlashAOESkill.swift
//  NinjaWarriors
//
//  Created by Joshen on 23/3/24.
//

import Foundation
class SlashAOESkill: EntitySpawnerSkill {
    var id: SkillID
    private var cooldownDuration: TimeInterval
    var cooldownRemaining: TimeInterval = 0

    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }

    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        // self.id = id
        self.cooldownDuration = cooldownDuration
    }

    func isOnCooldown() -> Bool {
       return cooldownRemaining > 0
    }
    
    func resetCooldown() {
        cooldownRemaining = 0
    }

    func decrementCooldown(deltaTime: TimeInterval) {
       cooldownRemaining = max(0, cooldownRemaining - deltaTime)
    }

    func activate(from entity: Entity, in manager: EntityComponentManager) {
       _ = spawnEntity(from: entity, in: manager)
       cooldownRemaining = cooldownDuration
    }

    // TODO: Remove hardcode and get shape from rigid body, rather than from entity
    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity {
        print("[SlashAOESkill] Activated by \(casterEntity)")
        let slashAOE = SlashAOE(id: RandomNonce().randomNonceString(), casterEntity: casterEntity)
        //manager.add(entity: slashAOE, isAdded: false)
        return slashAOE
    }
}
