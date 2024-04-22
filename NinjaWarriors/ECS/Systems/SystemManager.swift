//
//  SystemManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

class SystemManager {
    private var systems: [System]

    init() {
        systems = []
    }

    func update(after time: TimeInterval) {
        for system in systems {
            system.update(after: time)
        }
    }

    func system<T: System>(ofType: T.Type) -> T? {
        for system in systems {
            if let specificSystem = system as? T {
                return specificSystem
            }
        }
        return nil
    }

    func add(system: System) {
        systems.append(system)
    }
}
