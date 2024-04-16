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
    var cooldownDuration: TimeInterval { get set }
    var audio: String { get }

    init(id: SkillID)

    func activate(from entity: Entity, in manager: EntityComponentManager)

    func wrapper() -> SkillWrapper
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
