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

    init(id: SkillID)

    func isOnCooldown() -> Bool

    func decrementCooldown(deltaTime: TimeInterval)

    func activate(from entity: Entity, in manager: EntityComponentManager)
}

protocol SelfModifyingSkill: Skill {
    func modifySelf()
}

protocol EntitySpawnerSkill: Skill {
    func spawnEntity(from casterEntity: Entity, in manager: EntityComponentManager) -> Entity
}

protocol CooldownModifierSkill: Skill {
    func modifyCooldowns()
}

protocol MovementSkill: Skill {
    func performMovement(on target: Entity)
}
