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
    let entityComponentManager = EntityComponentManager()
    let systemManager = SystemManager()
    var gameLoopManager = GameLoopManager()

    init() {
        setupGameLoop()
        setupSystems()
    }

    private func setupGameLoop() {
        gameLoopManager.onUpdate = { [weak self] deltaTime in
            self?.update(deltaTime: deltaTime)
        }
    }

    private func setupSystems() {
        systemManager.add(system: TransformHandler(for: entityComponentManager))
        systemManager.add(system: CollisionManager(for: entityComponentManager))
        systemManager.add(system: RigidbodyHandler(for: entityComponentManager))
    }

    func start() {
        gameLoopManager.start()
    }

    func stop() {
        gameLoopManager.stop()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(after: deltaTime)
    }
}
