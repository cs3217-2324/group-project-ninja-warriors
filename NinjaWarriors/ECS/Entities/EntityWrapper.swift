//
//  EntityWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 21/3/24.
//

import Foundation

class EntityWrapper: FactoryWrapper {
    typealias Item = EntityWrapper

    var id: EntityID
    //var entityType: String

    init(id: EntityID/*, entityType: String*/) {
        self.id = id
        //self.entityType = entityType
    }

    // TODO: FIX THIS ASAP
    open func toEntity() -> Entity? {
        return nil
        //Obstacle(id: "1")
    }
}
