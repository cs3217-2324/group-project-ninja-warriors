//
//  CombatSystem.swift
//  NinjaWarriors
//
//  Created by proglab on 15/4/24.
//

import Foundation

class CombatSystem: System {
    var manager: EntityComponentManager
    private var eventQueue: [CombatEvent] = []

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func queueEvent(_ event: CombatEvent) {
        eventQueue.append(event)
    }

    func update(after time: TimeInterval) {
        while !eventQueue.isEmpty {
            let event = eventQueue.removeFirst()
            applyEvent(event)
        }
    }

    private func applyEvent(_ event: CombatEvent) {
        guard let healthComponent = manager.getComponent(ofType: Health.self, for: event.target) else {
            print("Health component not found for entity ID \(event.target)")
            return
        }

        switch event.type {
        case .damage:
            healthComponent.health -= event.amount
            if healthComponent.health <= 0 { handleDeath(for: event.target) }
        case .heal:
            healthComponent.health += event.amount
            healthComponent.health = min(healthComponent.health, healthComponent.maxHealth)
        }
    }

    private func handleDeath(for entity: Entity) {
        print("Entity \(entity.id) died.")
        // Additional logic for handling entity death, if necessary
    }
}
