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
    private var invulnerabilityDuration: TimeInterval = 2.0
    var audio = "shield"

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

    func updateAttributes(_ newDodgeSkill: DodgeSkill) {
        self.id = newDodgeSkill.id
        self.cooldownDuration = newDodgeSkill.cooldownDuration
        self.invulnerabilityDuration = newDodgeSkill.invulnerabilityDuration
    }

    func modifySelf(_ entity: Entity, in manager: EntityComponentManager) {
        if let dodgeComponent = manager.getComponent(ofType: Dodge.self, for: entity) {
            dodgeComponent.isEnabled = true
            dodgeComponent.invulnerabilityDuration = self.invulnerabilityDuration
            dodgeComponent.elapsedTimeSinceEnabled = 0
            manager.add(entity: entity, components: [dodgeComponent], isAdded: false)
        } else {
            let dodgeComponent = Dodge(id: RandomNonce().randomNonceString(),
                                       entity: entity, isEnabled: true,
                                       invulnerabilityDuration: self.invulnerabilityDuration)
            manager.add(entity: entity, components: [dodgeComponent], isAdded: false)
        }
    }

    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "DodgeSkill", cooldownDuration: cooldownDuration)
    }
}
