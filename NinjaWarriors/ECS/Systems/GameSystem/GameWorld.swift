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
    // TODO: entityComponentManager need to have access to database so that other players will know
    // what components others have, as well as to add entity on the fly
    var entityComponentManager = EntityComponentManager()
    let systemManager = SystemManager()
    var gameLoopManager = GameLoopManager()
    var gameControl: GameControl = JoystickControl()
    var updateViewModel: () -> Void = {}

    init() {
        setupGameLoop()

        let transformHandler = TransformHandler(for: entityComponentManager)
        let rigidbodyHandler = RigidbodyHandler(for: entityComponentManager, with: gameControl)
        let collisionManager = CollisionManager(for: entityComponentManager)
        let skillsManager = SkillCasterSystem(for: entityComponentManager)
        let healthManager = HealthSystem(for: entityComponentManager)

        systemManager.add(system: transformHandler)
        systemManager.add(system: rigidbodyHandler)
        systemManager.add(system: collisionManager)
        systemManager.add(system: skillsManager)
        systemManager.add(system: healthManager)
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
