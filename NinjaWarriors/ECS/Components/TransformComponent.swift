//
//  TransformComponent.swift
//  NinjaWarriors
//
//  Created by proglab on 20/3/24.
//

import Foundation

class TransformComponent: Component {
    var position: Point
    var rotation: Double
    var shape: Shape

    // Initialize TransformComponent with position, rotation, and optionally a shape
    init(id: ComponentID, entity: Entity, position: Point, rotation: Double, shape: Shape) {
        self.position = position
        self.rotation = rotation
        self.shape = shape
        super.init(id: id, entity: entity)
//        updateShapeCenter()
    }

//    Ideally, components should not have functions. Leaving this here in case we need them -joshen
//    // Function to update the TransformComponent's position
//    func updatePosition(to newPosition: Point) {
//        self.position = newPosition
//        updateShapeCenter()
//    }
//
//    // Function to update the TransformComponent's rotation
//    func updateRotation(to newRotation: Double) {
//        self.rotation = newRotation
//        // Optionally, we can also adjust the shape's orientation here
//        shape?.orientation = newRotation
//    }
//
//    // Function to update the Shape's center based on the TransformComponent's position
//
//    private func updateShapeCenter() {
//        guard let shape = shape else { return }
//        // Assuming the center of the Shape is meant to be a direct offset of the position,
//        // we can directly assign the position to the shape's center.
//        // If a different kind of offset is needed, adjust accordingly.
//        shape.center = position
//    }
}
