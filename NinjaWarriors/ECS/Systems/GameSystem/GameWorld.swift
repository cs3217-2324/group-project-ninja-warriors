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
    var achievementManager: AchievementManager?
    let systemManager = SystemManager()
    var gameLoopManager = GameLoopManager()
    var gameControl: GameControl
    var gameMode: GameMode
    var updateViewModel: () -> Void = {}
    var isGameOver: Bool = false

    init(for match: String, gameControl: GameControl = JoystickControl(),
         metricsRecorder: EntityMetricsRecorder, achievementManager: AchievementManager?, gameMode: GameMode) {
        self.entityComponentManager = EntityComponentManager(for: match, metricsRecorder: metricsRecorder)
        self.gameControl = gameControl
        self.achievementManager = achievementManager
        self.gameMode = gameMode

        // let transformHandler = TransformHandler(for: entityComponentManager)
        let collisionManager = CollisionManager(for: entityComponentManager)
        let rigidbodyHandler = RigidbodyHandler(for: entityComponentManager, with: gameControl)
        let skillsManager = SkillCasterSystem(for: entityComponentManager)
        let dodgeManager = DodgeSystem(for: entityComponentManager)
        let combatSystem = CombatSystem(for: entityComponentManager)
        let healthManager = HealthSystem(for: entityComponentManager)
        let environmentEffectSystem = EnvironmentEffectSystem(for: entityComponentManager)
        let lifespanManager = LifespanSystem(for: entityComponentManager)
        let collectionSystem = CollectionSystem(for: entityComponentManager)
        // let scoreManager = ScoreSystem(for: entityComponentManager)
        let respawnSystem = RespawnSystem(for: entityComponentManager)
        let destroyManager = DestroySystem(for: entityComponentManager)

        // systemManager.add(system: transformHandler)
        systemManager.add(system: collisionManager)
        systemManager.add(system: rigidbodyHandler)
        systemManager.add(system: skillsManager)
        systemManager.add(system: dodgeManager)
        systemManager.add(system: combatSystem)
        systemManager.add(system: healthManager)
        systemManager.add(system: environmentEffectSystem)
        systemManager.add(system: lifespanManager)
        systemManager.add(system: collectionSystem)
        // systemManager.add(system: scoreManager)
        systemManager.add(system: respawnSystem)
        systemManager.add(system: destroyManager)

        setupGameLoop()
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

        if gameMode.isGameOver(for: self) {
            self.gameLoopManager.stop()
            self.isGameOver = true
        }
    }

    func getRepository() -> MetricsRepository {
        entityComponentManager.entityMetricsRecorder.getRepository()
    }
}
