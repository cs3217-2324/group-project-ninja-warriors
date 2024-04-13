//
//  DodgeSystem.swift
//  NinjaWarriors
//
//  Created by Joshen on 1/4/24.
//

import Foundation

class DodgeSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let dodgeComponents = manager.getAllComponents(ofType: Dodge.self)

        for dodgeComponent in dodgeComponents where dodgeComponent.isEnabled {
            updateElapsedTime(for: dodgeComponent, deltaTime: time)
            disableIfExpired(dodgeComponent)
        }
    }

    private func updateElapsedTime(for dodgeComponent: Dodge, deltaTime: TimeInterval) {
        dodgeComponent.elapsedTimeSinceEnabled += deltaTime
    }

    private func disableIfExpired(_ dodgeComponent: Dodge) {
        if dodgeComponent.elapsedTimeSinceEnabled > dodgeComponent.invulnerabilityDuration {
            print(dodgeComponent.elapsedTimeSinceEnabled, dodgeComponent.invulnerabilityDuration)
            dodgeComponent.isEnabled = false
            dodgeComponent.elapsedTimeSinceEnabled = 0
        }
    }
}
