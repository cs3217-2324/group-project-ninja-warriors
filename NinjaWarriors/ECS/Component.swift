//
//  Component.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

typealias ComponentID = UUID
//TODO: check whether a protocol is usable here (probably not due to unowned)
class Component: Hashable {
    var id: ComponentID
    unowned var entity: Entity
    
    init(id: UUID, entity: Entity) {
        self.id = id
        self.entity = entity
    }
    
    static func == (lhs: Component, rhs: Component) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
