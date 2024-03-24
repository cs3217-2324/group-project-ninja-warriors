//
//  Skill.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 19/3/24.
//

import Foundation

typealias SkillID = String
protocol Skill {
    var id: SkillID { get }
    var cooldownRemaining: TimeInterval { get set }

    init(id: SkillID)

    func isOnCooldown() -> Bool
    
    func resetCooldown()

    func decrementCooldown(deltaTime: TimeInterval)

    func activate(from entity: Entity, in manager: EntityComponentManager)
}

protocol SelfModifyingSkill: Skill {
    func modifySelf(_ entity: Entity, in manager: EntityComponentManager)
}

protocol EntitySpawnerSkill: Skill {
    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity
}

protocol CooldownModifierSkill: Skill {
    func modifyCooldowns(_ entity: Entity, in manager: EntityComponentManager)
}

protocol MovementSkill: Skill {
    func performMovement(on target: Entity, in manager: EntityComponentManager)
}
