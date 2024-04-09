//
//  DodgeSystem.swift
//  NinjaWarriors
//
//  Created by Joshen on 1/4/24.
//

import Foundation

class DodgeSystem: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
    }
}
