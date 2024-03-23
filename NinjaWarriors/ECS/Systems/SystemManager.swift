//
//  SystemManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

class SystemManager {
    private var systems: [String: System]

    init() {
        systems = [:]
    }

    func update(after time: TimeInterval) {
        systems.values.forEach { system in
            system.update(after: time)
        }
    }

    func system<T: System>(ofType: T.Type) -> T? {
        let systemName = String(describing: ofType)
        return systems[systemName] as? T
    }

    func add(system: System) {
        let systemName = String(describing: type(of: system))
        systems[systemName] = system
    }
}
