//
//  Shape.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

// TODO: Update shape to conform to Component
class Shape: Component {
    var center: Point
    var orientation: Double?
    var halfLength: Double
    var edges: [Line]?
    var vertices: [Point]?

    init (id: String, entity: Entity, center: Point, halfLength: Double,
          orientation: Double, edges: [Line], vertices: [Point]) {
        self.center = center
        self.halfLength = halfLength
        self.orientation = orientation
        self.edges = edges
        self.vertices = vertices
        super.init(id: id, entity: entity)
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

    func makeDeepCopy() -> Shape? {
        guard let edges = edges, let orientation = orientation, let vertices = vertices else {
            return nil
        }
        return Shape(id: id, entity: entity, center: center, halfLength: halfLength,
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
        if let edges = edges {
            return edges.map { $0.toLineWrapper() }
        } else {
            return [defaultLine]
        }
    }

    private func createVerticesWrapper() -> [PointWrapper] {
        if let vertices = vertices {
            return vertices.map { $0.toPointWrapper() }
        } else {
            return [createDefaultPoint()]
        }
    }

    func toShapeWrapper() -> ShapeWrapper {
        let defaultLine = createDefaultLine()
        let edgesWrapper = createEdgesWrapper(defaultLine)
        let verticesWrapper = createVerticesWrapper()

        return ShapeWrapper(center: center.toPointWrapper(),
                            orientation: orientation ?? 0.0,
                            halfLength: halfLength,
                            edges: edgesWrapper,
                            vertices: verticesWrapper)
    }
}
