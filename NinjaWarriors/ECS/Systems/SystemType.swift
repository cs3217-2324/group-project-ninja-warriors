//
//  SystemType.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 27/3/24.
//

import Foundation

struct SystemType: Hashable {
    let type: System.Type

    init(_ type: System.Type) {
        self.type = type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    static func ==(lhs: SystemType, rhs: SystemType) -> Bool {
        return lhs.type == rhs.type
    }
}


