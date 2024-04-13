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
    var halfLength: Double = 25.0
    var orientation: Double = 0.0
    var edges: [Line] = []
    var vertices: [Point] = []

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
        return vertices.count
    }

    func contains(point: Point) -> Bool {
        assertionFailure("Not implemented, should be overriden in subclass")
        return false
    }

    func deepCopy() -> Shape {
        return Shape(center: center, offset: offset, halfLength: halfLength,
                     orientation: orientation, edges: edges, vertices: vertices)
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
        var edgesWrapper: [LineWrapper] = []
        for edge in edges {
            edgesWrapper.append(edge.wrapper())
        }
        return edgesWrapper
    }

    private func createVerticesWrapper() -> [PointWrapper] {
        var pointWrapper: [PointWrapper] = []
        for vertex in vertices {
            pointWrapper.append(vertex.wrapper())
        }
        return pointWrapper
    }

    func wrapper() -> ShapeWrapper {
        let defaultLine = createDefaultLine()
        let edgesWrapper = createEdgesWrapper(defaultLine)
        let verticesWrapper = createVerticesWrapper()

        return ShapeWrapper(center: center.wrapper(),
                            offset: offset.wrapper(),
                            orientation: orientation,
                            halfLength: halfLength,
                            edges: edgesWrapper,
                            vertices: verticesWrapper)
    }
}

extension Shape {
    func updateAttributes(_ newShape: Shape) {
        center.updateAttributes(newShape.center)
        offset.updateAttributes(newShape.offset)

        halfLength = newShape.halfLength
        orientation = newShape.orientation

        for (index, newLine) in newShape.edges.enumerated() {
            if index < edges.count {
                edges[index].updateAttributes(newLine)
            } else {
                edges.append(newLine)
            }
        }

        for (index, newPoint) in newShape.vertices.enumerated() {
            if index < vertices.count {
                vertices[index].updateAttributes(newPoint)
            } else {
                vertices.append(newPoint)
            }
        }
    }
}
