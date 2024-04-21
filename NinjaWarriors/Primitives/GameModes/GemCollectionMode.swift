//
//  GemCollectionMode.swift
//  NinjaWarriors
//
//  Created by proglab on 21/4/24.
//

import Foundation

class GemCollectionMode: GameMode {
    var hasStarted: Bool = false

    func isGameOver(for gameWorld: GameWorld) -> Bool {
        let collectors = gameWorld.entityComponentManager.getAllComponents(ofType: Collector.self)
        for collector in collectors {
            if collector.countItem(of: "Gem") >= 10 {
                return true
            }
        }
        return false
    }

    func start() {
        hasStarted = true
    }
}
