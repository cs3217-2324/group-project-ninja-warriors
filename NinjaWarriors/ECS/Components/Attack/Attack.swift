//
//  Attack.swift
//  NinjaWarriors
//
//  Created by proglab on 6/4/24.
//

import Foundation

class Attack: Component {
    var attackStrategy: AttackStrategy
    var damage: Double
    var activated: Bool

    init(id: ComponentID, entity: Entity, attackStrategy: AttackStrategy,
         damage: Double, activated: Bool = false) {
        self.attackStrategy = attackStrategy
        self.damage = damage
        self.activated = activated
        super.init(id: id, entity: entity)
    }

    func attackIfPossible(health: Health, manager: EntityComponentManager) {
        let attacker = self.entity
        let attackee = health.entity
        if attackStrategy.canAttack(attacker: attacker, attackee: attackee, manager: manager) {

            attackStrategy.attack(health: health, damage: self.damage)


            manager.componentsQueue.addComponent(health)


            /*
            let newHealth = health.deepCopy()
            manager.remove(ofComponentType: Health.self, from: attackee)
            let latestHealth = newHealth.changeEntity(to: attackee)

            guard let latestLatestHealthComponent = latestHealth as? Health else {
                return
            }
            latestLatestHealthComponent.health -= self.damage

            //manager.componentsQueue.addComponent(newHealth)\
            */

            /*
            DispatchQueue.main.sync {
                health.health -= self.damage
            }

            let task = Task(priority: .userInitiated) {
                do {
                    try await manager.manager.uploadEntity(entity: health.entity,
                                                           components: [health])
                    // Upload successful, continue with your logic here
                } catch {
                    // Handle the error
                    print("Error uploading entity: \(error)")
                }
            }
            */

            // Wait for the task to complete before continuing
            //try? task.value.get()


            /*
            Task {  
                try await manager.manager.uploadEntity(entity: latestLatestHealthComponent.entity,
                                                       components: [latestLatestHealthComponent])
            }
            */

        }
    }

    func setToActivated() {
        self.activated = true
    }
}
