//
//  SystemManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

class SystemManager {
    private var systems: [SystemType: System]

    init() {
        systems = [:]
    }

    func update(after time: TimeInterval) {
        systems.values.forEach { system in
            system.update(after: time)
        }
    }

    func system<T: System>(ofType: T.Type) -> T? {
        return systems[SystemType(ofType)] as? T
    }

    func add(system: System) {
        systems[SystemType(type(of: system))] = system
    }
}
