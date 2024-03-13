//
//  GameObject.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

class GameObject {

    var center: Point
    var orientation: Double?
    var halfLength: Double
    var edges: [Line]?

    init (center: Point, halfLength: Double) {
        self.center = center
        self.halfLength = halfLength
    }

    init (center: Point, halfLength: Double, edges: [Line]) {
        self.center = center
        self.halfLength = halfLength
        self.edges = edges
    }

    init (center: Point, halfLength: Double, orientation: Double) {
        self.center = center
        self.halfLength = halfLength
        self.orientation = orientation
    }

    init (center: Point, halfLength: Double, orientation: Double, edges: [Line]) {
        self.center = center
        self.halfLength = halfLength
        self.orientation = orientation
        self.edges = edges
    }

    func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        let collisionDetector = CollisionDetector()
        return collisionDetector.checkSafeToInsert(source: self, with: gameObject)
    }

    func makeDeepCopy() -> GameObject {
        guard let edges = edges, let orientation = orientation else {
            return GameObject(center: center, halfLength: halfLength)
        }
        return GameObject(center: center, halfLength: halfLength, orientation: orientation, edges: edges)
    }
}
