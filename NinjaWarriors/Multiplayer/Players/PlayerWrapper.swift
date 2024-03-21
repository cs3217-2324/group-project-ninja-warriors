//
//  PlayerWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class PlayerWrapper: EntityWrapper {
   var components: [ComponentWrapper]?

    init(id: EntityID, shape: ShapeWrapper, components: [ComponentWrapper]? = nil) {
        self.components = components
        super.init(id: id, shape: shape)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        var componentsUnwrap: [Component] = []
        guard let components = components else {
            return Player(id: id, shape: shape.toShape())
        }
        for component in components {
            if let componentUnwrap = component.toComponent() {
                componentsUnwrap.append(componentUnwrap)
            }
        }
        return Player(id: id, shape: shape.toShape(), components: componentsUnwrap)
    }
}
