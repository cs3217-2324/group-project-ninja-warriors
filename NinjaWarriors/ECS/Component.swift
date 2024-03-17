//
//  Component.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

//TODO: check whether a protocol is usable here (probably not due to unowned)
class Component {
    var id: UUID
    unowned var entity: Entity
    
    init(id: UUID, entity: Entity) {
        self.id = id
        self.entity = entity
    }
}
