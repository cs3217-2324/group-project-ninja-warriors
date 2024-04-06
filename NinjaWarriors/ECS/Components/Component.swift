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

    func updateAttributes(_ newComponent: Component) {
        self.id = newComponent.id
    }

    func changeEntity(to entity: Entity) -> Component {
        Component(id: self.id, entity: entity)
    }

    func wrapper() -> ComponentWrapper? { return nil }
}
