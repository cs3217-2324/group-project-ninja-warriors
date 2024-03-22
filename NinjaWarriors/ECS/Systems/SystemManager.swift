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
        // print("[SystemManager] System count", systems.count)
        systems.forEach { $0.update(after: time) }
    }

    func system<T: System>(ofType: T.Type) -> T? {
        // TODO: if guaranteed that there is only one system of a given type, then can index by type name
        return systems.first(where: {$0 is T}) as? T
    }

    func add(system: System) {
        systems.append(system)
    }
}
