//
//  Shape.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

class Shape {
    var center: Point
    var offset: Point
    var halfLength: Double
    var orientation: Double?
    var edges: [Line]?
    var vertices: [Point]?

    init (center: Point, halfLength: Double) {
        self.center = center
        self.offset = center
        self.halfLength = halfLength
    }

    init (center: Point, halfLength: Double,
          orientation: Double, edges: [Line], vertices: [Point]) {
        self.center = center
        self.offset = center
        self.halfLength = halfLength
        self.orientation = orientation
        self.edges = edges
        self.vertices = vertices
    }

    init (center: Point, offset: Point, halfLength: Double,
          orientation: Double, edges: [Line], vertices: [Point]) {
        self.center = center
        self.offset = center
        self.halfLength = halfLength
        self.orientation = orientation
        self.edges = edges
        self.vertices = vertices
    }

    func getCenter() -> CGPoint {
        CGPoint(x: center.xCoord, y: center.yCoord)
    }

    func getOffset() -> CGPoint {
        CGPoint(x: offset.xCoord, y: offset.yCoord)
    }

    func resetOffset() {
        offset = center
    }

    func countVetices() -> Int {
        guard let vertices = vertices else {
            return 0
        }
        return vertices.count
    }

    func deepCopy() -> Shape {
        if let edges = edges, let orientation = orientation, let vertices = vertices {
            return Shape(center: center, offset: offset, halfLength: halfLength,
                         orientation: orientation, edges: edges, vertices: vertices)
        } else {
            return Shape(center: center, halfLength: halfLength)
        }

    }
}

extension Shape {
    private func createDefaultPoint() -> PointWrapper {
        return PointWrapper(xCoord: 0.0, yCoord: 0.0, radial: 0.0, theta: 0.0)
    }

    private func createDefaultLine() -> LineWrapper {
        let defaultPoint = createDefaultPoint()
        let defaultVector = VectorWrapper(horizontal: 0.0, vertical: 0.0)
        return LineWrapper(start: defaultPoint, end: defaultPoint, vector: defaultVector)
    }

    private func createEdgesWrapper(_ defaultLine: LineWrapper) -> [LineWrapper] {
        if let edges = edges {
            return edges.map { $0.wrapper() }
        } else {
            return [defaultLine]
        }
    }

    private func createVerticesWrapper() -> [PointWrapper] {
        if let vertices = vertices {
            return vertices.map { $0.wrapper() }
        } else {
            return [createDefaultPoint()]
        }
    }

    func wrapper() -> ShapeWrapper {
        let defaultLine = createDefaultLine()
        let edgesWrapper = createEdgesWrapper(defaultLine)
        let verticesWrapper = createVerticesWrapper()

        return ShapeWrapper(center: center.wrapper(),
                            offset: offset.wrapper(),
                            orientation: orientation ?? 0.0,
                            halfLength: halfLength,
                            edges: edgesWrapper,
                            vertices: verticesWrapper)
    }
}
