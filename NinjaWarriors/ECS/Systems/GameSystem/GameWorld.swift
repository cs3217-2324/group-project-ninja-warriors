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
    var gameControl: GameControl = JoystickControl()
    var updateViewModel: () -> Void = {}

    init(for match: String) {
        self.entityComponentManager = EntityComponentManager(for: match)

        setupGameLoop()
        
        let transformHandler = TransformHandler(for: entityComponentManager)
        let rigidbodyHandler = RigidbodyHandler(for: entityComponentManager, with: gameControl)
        let collisionManager = CollisionManager(for: entityComponentManager)
        let skillsManager = SkillCasterSystem(for: entityComponentManager)
        let healthManager = HealthSystem(for: entityComponentManager)
        let scoreManager = ScoreSystem(for: entityComponentManager)
        let destroyManager = DestroySystem(for: entityComponentManager)

        systemManager.add(system: transformHandler)
        systemManager.add(system: rigidbodyHandler)
        systemManager.add(system: collisionManager)
        systemManager.add(system: skillsManager)
        systemManager.add(system: healthManager)
        systemManager.add(system: scoreManager)
        systemManager.add(system: destroyManager)
    }

    func setInput(_ vector: CGVector, for entity: Entity) {
        gameControl.setInput(vector, for: entity)
    }

    private func setupGameLoop() {
        //gameLoopManager.onUpdate = { [unowned self] deltaTime in
        gameLoopManager.onUpdate = { [weak self] deltaTime in
            guard let self = self else { return }
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
