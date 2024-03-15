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
    var vertices: [Point]?

    init (center: Point, halfLength: Double) {
        self.center = center
        self.halfLength = halfLength
    }

    init (center: Point, halfLength: Double, edges: [Line], vertices: [Point]) {
        self.center = center
        self.halfLength = halfLength
        self.edges = edges
        self.vertices = vertices
    }

    init (center: Point, halfLength: Double, orientation: Double) {
        self.center = center
        self.halfLength = halfLength
        self.orientation = orientation
    }

    init (center: Point, halfLength: Double, orientation: Double, edges: [Line], vertices: [Point]) {
        self.center = center
        self.halfLength = halfLength
        self.orientation = orientation
        self.edges = edges
        self.vertices = vertices
    }

    func getCenter() -> CGPoint {
        CGPoint(x: center.xCoord, y: center.yCoord)
    }

    func countVetices() -> Int {
        guard let vertices = vertices else {
            return 0
        }
        return vertices.count
    }

    func checkSafeToInsert(with gameObject: GameObject) -> Bool {
        let collisionDetector = CollisionDetector()
        return collisionDetector.checkSafeToInsert(source: self, with: gameObject)
    }

    func makeDeepCopy() -> GameObject {
        guard let edges = edges, let orientation = orientation, let vertices = vertices else {
            return GameObject(center: center, halfLength: halfLength)
        }
        return GameObject(center: center, halfLength: halfLength, orientation: orientation, edges: edges, vertices: vertices)
    }

    func toGameObjectWrapper() -> GameObjectWrapper {
        let pointWrapper = center.toPointWrapper()
        var edgesWrapper: [LineWrapper] = []
        if let edges = edges {
            for edge in edges {
                edgesWrapper.append(edge.toLineWrapper())
            }
        }
        var verticesWrapper: [PointWrapper] = []
        if let vertices = vertices {
            for vertex in vertices {
                verticesWrapper.append(vertex.toPointWrapper())
            }
        }

        return GameObjectWrapper(center: center.toPointWrapper(),
                          orientation: orientation ?? 0.0,
                          halfLength: halfLength,
                          edges: edgesWrapper,
                          vertices: verticesWrapper)
    }
}
