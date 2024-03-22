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
    var cooldown: Double { get set }
    var isOnCooldown: Bool { get }

    func activate()
}

protocol SelfModifyingSkill: Skill {
    func modifySelf()
}

protocol EntitySpawnerSkill: Skill {
    func spawnEntity()
}

protocol CooldownModifierSkill: Skill {
    func modifyCooldowns()
}

protocol MovementSkill: Skill {
    func performMovement(on target: Entity)
}
