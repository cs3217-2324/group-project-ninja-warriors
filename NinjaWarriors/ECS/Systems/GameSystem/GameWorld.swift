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

        // TODO: set up different systems
    }

    private func setupGameLoop() {
        gameLoopManager.onUpdate = { [weak self] deltaTime in
            self?.update(deltaTime: deltaTime)
        }
    }

    func start() {
        gameLoopManager.start()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(after: deltaTime)
    }
}
