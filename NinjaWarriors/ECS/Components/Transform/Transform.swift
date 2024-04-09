//
//  Transform.swift
//  NinjaWarriors
//
//  Created by proglab on 1/4/24.
//

import Foundation

class Transform: Component {
    var position: Point
    var rotation: Double

    init(id: ComponentID, entity: Entity, position: Point, rotation: Double) {
        self.position = position
        self.rotation = rotation
        super.init(id: id, entity: entity)
    }

    override func wrapper() -> ComponentWrapper? {
        guard let entityWrapper = entity.wrapper() else {
            return nil
        }
        return TransformWrapper(id: id, entity: entityWrapper, position: position.wrapper(), rotation: rotation)
    }
}
