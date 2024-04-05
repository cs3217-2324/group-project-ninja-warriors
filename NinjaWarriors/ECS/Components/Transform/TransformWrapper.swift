//
//  TransformWrapper.swift
//  NinjaWarriors
//
//  Created by proglab on 1/4/24.
//

import Foundation

struct TransformWrapper: ComponentWrapper {
    var id: ComponentID
    var entity: EntityWrapper
    var position: PointWrapper
    var rotation: Double

    func toComponent(entity: Entity) -> Component? {
        return Transform(id: id, entity: entity, position: position.toPoint(), rotation: rotation)
    }
}
