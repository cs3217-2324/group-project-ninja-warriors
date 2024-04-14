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
    var gameMode: GameMode
    var updateViewModel: () -> Void = {}
    var isGameOver: Bool = false

    init(for match: String, gameControl: GameControl = JoystickControl(), gameMode: GameMode) {
        self.entityComponentManager = EntityComponentManager(for: match)
        self.gameControl = gameControl
        self.gameMode = gameMode

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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.gameLoopManager.stop()
                self.isGameOver = true
                self.updateViewModel()
            }
        }
    }
}
