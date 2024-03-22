//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    let id: EntityID
    var shape: Shape
    internal var components: [Component]?

    init(id: EntityID, shape: Shape, components: [Component]? = nil) {
        self.id = id
        self.shape = shape
        self.components = components
    }

    func getInitializingComponents() -> [Component] {
        guard let components = components else { return [] }
        return components
    }

    // TODO: Must remove this and make change based on system instead
    /// *
    func getPosition() -> CGPoint {
        shape.getCenter()
    }

    func changePosition(to center: Point) {
        shape.center = center
    }
    // */

    func wrapper() -> EntityWrapper? {
        var componentsWrapper: [ComponentWrapper] = []
        guard let components = components else {
            return PlayerWrapper(id: id, shape: shape.toShapeWrapper())
        }
        for component in components {
            if let componentWrap = component.wrapper() {
                componentsWrapper.append(componentWrap)
            }
        }
        return PlayerWrapper(id: id, shape: shape.toShapeWrapper(), components: componentsWrapper)
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
