//
//  GameEngine.swift
//  NinjaWarriors
//
//  Created by proglab on 19/3/24.
//

import Foundation

// TODO: Deprecate if not used
class GameEngine {
    private let entityComponentManager: EntityComponentManager
    private let systemManager: SystemManager

    init() {
        print("=== [GameEngine] INIT ===")
        entityComponentManager = EntityComponentManager()
        systemManager = SystemManager()
        setUpSystems()
    }

    private func setUpSystems() {
        // TODO: Initialize and add systems to SystemManager, or consider doing this in init() of SystemManager
    }

    func update(after time: TimeInterval) {
        systemManager.update(after: time)
    }
}
