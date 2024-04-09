//
//  TransformHandler.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 20/3/24.
//

import Foundation

class TransformHandler: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) { }
}
