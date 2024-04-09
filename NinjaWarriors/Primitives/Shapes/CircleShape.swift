//
//  CircleShape.swift
//  NinjaWarriors
//
//  Created by Joshen on 23/3/24.
//

import Foundation

class CircleShape: Shape {
    // Since a circle can be fully described by its center and radius,
    // there's no need to override properties like edges and vertices for basic representation.
    // But, we'll add an initializer that emphasizes the circle's definition.

    init(center: Point, radius: Double) {
        super.init(center: center, halfLength: radius)
        // Optionally, calculate edges and vertices if needed for collision detection or other purposes.
        self.orientation = 0 // Default orientation as circle's orientation is irrelevant
        // For simulation or rendering where edges/vertices might be needed, consider approximating the circle with a polygon.
    }

    func area() -> Double {
        return Double.pi * halfLength * halfLength
    }

    func contains(point: Point) -> Bool {
        return center.distance(to: point) <= halfLength
    }

    override func deepCopy() -> Shape {
        return CircleShape(center: self.center, radius: self.halfLength)
    }
}
