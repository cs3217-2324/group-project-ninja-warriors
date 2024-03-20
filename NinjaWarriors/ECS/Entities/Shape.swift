//
//  Shape.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

// TODO: Update shape to conform to Component, rename to sh
class Shape {
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

    func checkSafeToInsert(with Shape: Shape) -> Bool {
        let collisionDetector = CollisionDetector()
        return collisionDetector.checkSafeToInsert(source: self, with: Shape)
    }

    func makeDeepCopy() -> Shape {
        guard let edges = edges, let orientation = orientation, let vertices = vertices else {
            return Shape(center: center, halfLength: halfLength)
        }
        return Shape(center: center, halfLength: halfLength,
                          orientation: orientation, edges: edges, vertices: vertices)
    }

    // TODO: Remove hardcoded values
    func toShapeWrapper() -> ShapeWrapper {
        let test = PointWrapper(xCoord: 10.0, yCoord: 10.0, radial: 10.0, theta: 10.0)
        var edgesWrapper: [LineWrapper] = []
        if let edges = edges {
            for edge in edges {
                edgesWrapper.append(edge.toLineWrapper())
            }
        }
        edgesWrapper = [LineWrapper(start: test, end: test, vector: VectorWrapper(horizontal: 10.0, vertical: 10.0))]
        var verticesWrapper: [PointWrapper] = []
        if let vertices = vertices {
            for vertex in vertices {
                verticesWrapper.append(vertex.toPointWrapper())
            }
        }
        verticesWrapper = [test, test]

        return ShapeWrapper(center: center.toPointWrapper(),
                          orientation: orientation ?? 0.0,
                          halfLength: halfLength,
                          edges: edgesWrapper,
                          vertices: verticesWrapper)
    }
}
