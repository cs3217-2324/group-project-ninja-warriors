//
//  GameWorld.swift
//  NinjaWarriors
//
//  Created by proglab on 20/3/24.
//

import Foundation
import SwiftUI

// Represents the game world, containing entities and systems
class GameWorld {
    var entityComponentManager: EntityComponentManager
    let systemManager = SystemManager()
    var gameLoopManager = GameLoopManager()
    var gameControl: GameControl
    var updateViewModel: () -> Void = {}

    init(for match: String, gameControl: GameControl = JoystickControl(), metricsRecorder: EntityMetricsRecorder) {
        self.entityComponentManager = EntityComponentManager(for: match, metricsRecorder: metricsRecorder)
        self.gameControl = gameControl

        setupGameLoop()

        let destroyManager = DestroySystem(for: entityComponentManager)
        let transformHandler = TransformHandler(for: entityComponentManager)
        let rigidbodyHandler = RigidbodyHandler(for: entityComponentManager, with: gameControl)
        let collisionManager = CollisionManager(for: entityComponentManager)
        let skillsManager = SkillCasterSystem(for: entityComponentManager)
        let healthManager = HealthSystem(for: entityComponentManager)
        let dodgeManager = DodgeSystem(for: entityComponentManager)
        let environmentEffectSystem = EnvironmentEffectSystem(for: entityComponentManager)
        let lifespanManager = LifespanSystem(for: entityComponentManager)
        let scoreManager = ScoreSystem(for: entityComponentManager)
        let combatSystem = CombatSystem(for: entityComponentManager)

        systemManager.add(system: transformHandler)
        systemManager.add(system: rigidbodyHandler)
        systemManager.add(system: collisionManager)
        systemManager.add(system: skillsManager)
        systemManager.add(system: healthManager)
        systemManager.add(system: scoreManager)
        systemManager.add(system: dodgeManager)
        systemManager.add(system: environmentEffectSystem)
        systemManager.add(system: lifespanManager)
        systemManager.add(system: destroyManager)
        systemManager.add(system: combatSystem)
    }

    func setInput(_ vector: CGVector, for entity: Entity) {
        gameControl.setInput(vector, for: entity)
    }

    private func setupGameLoop() {
        gameLoopManager.onUpdate = { [unowned self] deltaTime in
            self.update(deltaTime: deltaTime)
            self.updateViewModel()
        }
    }

    func start() {
        gameLoopManager.start()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(after: deltaTime)
    }
}
