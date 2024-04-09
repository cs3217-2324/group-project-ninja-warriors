//
//  Component.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

typealias ComponentID = String

class Component: Hashable {
    var id: ComponentID
    unowned var entity: Entity


    var positionDidChange: (() -> Void)?

    func notifyPositionChange() {
        positionDidChange?()
    }

    init(id: ComponentID, entity: Entity) {
        self.id = id
        self.entity = entity
    }

    static func == (lhs: Component, rhs: Component) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

     func wrapper() -> ComponentWrapper? { return nil }
}
