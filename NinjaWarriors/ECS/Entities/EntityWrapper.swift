//
//  EntityWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 21/3/24.
//

import Foundation

class EntityWrapper: FactoryWrapper {
    typealias Item = /*EntityWrapper*/ PlayerWrapper
    // var id: EntityID

    /*@CodableWrapper*/ var id: EntityID
    /*@CodableWrapper*/ var shape: ShapeWrapper

    init(id: EntityID, shape: ShapeWrapper) {
        self.id = id
        self.shape = shape
    }

    func toEntity() -> Entity? { return nil }
}
