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
    var shape: ShapeWrapper
    // var components: [Component]?

    init(id: EntityID, shape: ShapeWrapper/*, components: [Component]?*/) {
        self.id = id
        self.shape = shape
        // self.components = components
    }

    func toEntity() -> Entity? { return nil }
}
