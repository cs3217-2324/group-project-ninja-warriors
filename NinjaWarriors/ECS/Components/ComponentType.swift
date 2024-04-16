//
//  ComponentType.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 27/3/24.
//

import Foundation

struct ComponentType: Hashable {
    let type: Component.Type

    init(_ type: Component.Type) {
        self.type = type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    static func == (lhs: ComponentType, rhs: ComponentType) -> Bool {
        return lhs.type == rhs.type
    }
}
