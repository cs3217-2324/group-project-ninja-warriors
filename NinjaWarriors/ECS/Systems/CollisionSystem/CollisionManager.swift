//
//  CollisionManager.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

class CollisionManager: System {
    var manager: EntityComponentManager

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let colliders = manager.getAllComponents(ofType: Collider.self)
        for collider in colliders {
            for otherCollider in colliders where otherCollider != collider {
                if !checkSafeToInsert(source: collider.colliderShape, with: otherCollider.colliderShape) {
                    collider.isColliding = true
                    otherCollider.isColliding = true
                    guard let otherCollidedEntityID = manager.getEntityId(from: otherCollider) else {
                        continue
                    }
                    guard let collidedEntityID = manager.getEntityId(from: collider) else {
                        continue
                    }
                    collider.collidedEntities.insert(otherCollidedEntityID)
                    otherCollider.collidedEntities.insert(collidedEntityID)
                }
            }
        }
    }

    func checkSafeToInsert(source object: Shape, with shape: Shape) -> Bool {
        isNotIntersecting(source: object, with: shape)
        && !isIntersecting(source: object, with: shape)
        && !isOverlap(source: object, with: shape)
        && !pointInside(object: object, point: shape.getCenter())
        && !pointInside(object: shape, point: object.getCenter())
    }

    // Non-Polygon - Non-Polygon Intersection (both do not contain edges)
    func isOverlap(source object: Shape, with shape: Shape) -> Bool {
        let distanceObjectSquared: Double = object.center.squareDistance(to: shape.center)
        let sumHalfLengthSquared: Double = (object.halfLength + shape.halfLength)
        * (object.halfLength + shape.halfLength)
        return distanceObjectSquared > sumHalfLengthSquared
    }

    // Polygon - Non-Polygon Intersection (one contains edges)
    func isIntersecting(source object: Shape, with shape: Shape) -> Bool {
        guard let edges = shape.edges ?? object.edges else {
            return false
        }
        return checkEdgePointIntersection(edges: edges, source: object, with: shape)
    }

    func checkEdgePointIntersection(edges: [Line], source object: Shape, with shape: Shape) -> Bool {
        var squaredLength: Double
        var objectCenter: Point

        if shape.edges != nil {
            squaredLength = object.halfLength * object.halfLength
            objectCenter = object.center
        } else {
            squaredLength = shape.halfLength * shape.halfLength
            objectCenter = shape.center
        }

        for edge in edges {
            guard objectCenter.squareDistance(to: edge.start) >= squaredLength else {
                return true
            }
            guard distanceFromPointToLine(point: objectCenter, line: edge) >= shape.halfLength else {
                return true
            }
        }
        return false
    }

    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        line.distanceFromPointToLine(point: point)
    }

    // Polygon - Polygon Intersection (both contains edges)
    func isNotIntersecting(source object: Shape, with shape: Shape) -> Bool {
        guard let edges = object.edges, let objectEdges = shape.edges else {
            return true
        }

        for edge in edges {
            for objectEdge in objectEdges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }
        guard edges[0].end.xCoord < objectEdges[1].start.xCoord
                && edges[1].start.xCoord > objectEdges[0].end.xCoord
                && edges[0].end.yCoord < objectEdges[1].start.yCoord
                && edges[1].start.yCoord > objectEdges[0].end.yCoord else {
            return true
        }
        return false
    }

    func checkStartEndIntersect(_ point1: Point, _ point2: Point, _ point3: Point) -> Bool {
        (point3.yCoord - point1.yCoord) * (point2.xCoord - point1.xCoord) >
        (point2.yCoord - point1.yCoord) * (point3.xCoord - point1.xCoord)
    }

    func linesIntersect(line1: Line, line2: Line) -> Bool {
        checkStartEndIntersect(line1.start, line2.start, line2.end) !=
        checkStartEndIntersect(line1.end, line2.start, line2.end) &&
        checkStartEndIntersect(line1.start, line1.end, line2.start) !=
        checkStartEndIntersect(line1.start, line1.end, line2.end)
    }

    func pointOnLine(point: Point, line: Line) -> Bool {
        (point.xCoord >= min(line.start.xCoord, line.end.xCoord) &&
         point.xCoord <= max(line.start.xCoord, line.end.xCoord)) &&
        (point.yCoord >= min(line.start.yCoord, line.end.yCoord) &&
         point.yCoord <= max(line.start.yCoord, line.end.yCoord))
    }

    // Object inside of another object check
    func pointInside(object: Shape, point: CGPoint) -> Bool {
        guard let vertices = object.vertices else {
            return false
        }
        let nvert: Int = object.countVetices()
        var isPointInside = false
        var iter = nvert - 1

        for curr in 0..<nvert {
            let isVertexPointYDiff = (vertices[curr].yCoord <= point.y) != (vertices[iter].yCoord <= point.y)
            let xDiff = (vertices[iter].xCoord - vertices[curr].xCoord)
            let pointVertexYDiff = (point.y - vertices[curr].yCoord)
            let vertexVertexYDiff = (vertices[iter].yCoord - vertices[curr].yCoord)

            if (isVertexPointYDiff)
                && (point.x <= xDiff * pointVertexYDiff / vertexVertexYDiff + vertices[curr].xCoord) {
                isPointInside.toggle()
            }
            iter = curr
        }
        return isPointInside
    }
}
