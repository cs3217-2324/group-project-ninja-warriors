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
            handleCollisions(for: collider, colliders: colliders)
        }
    }

    private func handleCollisions(for collider: Collider, colliders: [Collider]) {
        var isSafeToInsert = true
        
        for otherCollider in colliders where otherCollider != collider {
            if !checkSafeToInsert(source: collider.colliderShape, with: otherCollider.colliderShape, isColliding: collider.isColliding, isOutOfBounds: collider.isOutOfBounds) {
                handleCollisionBetween(collider, and: otherCollider)
                isSafeToInsert = false
                break
            }
        }

        if isSafeToInsert {
            handleBoundaries(for: collider)
        }
    }

    private func handleCollisionBetween(_ collider: Collider, and otherCollider: Collider) {
        collider.isColliding = true

        if let otherCollidedEntityID = manager.getEntityId(from: otherCollider),
           let collidedEntityID = manager.getEntityId(from: collider) {
            collider.collidedEntities.insert(otherCollidedEntityID)
            otherCollider.collidedEntities.insert(collidedEntityID)
        }
    }

    private func handleBoundaries(for collider: Collider) {
        if !intersectingBoundaries(source: collider.colliderShape, isColliding: collider.isColliding) {
            collider.isOutOfBounds = false
            collider.isColliding = false
            collider.colliderShape.resetOffset()
            collider.collidedEntities.removeAll()
        } else {
            collider.isOutOfBounds = true
            collider.isColliding = true
        }
    }

    func checkSafeToInsert(source object: Shape, with shape: Shape,
                           isColliding: Bool, isOutOfBounds: Bool) -> Bool {
        var shapeCenter: CGPoint
        var objectCenter: CGPoint

        if isColliding {
            shapeCenter = shape.getCenter()
            objectCenter = object.getCenter()
        } else {
            shapeCenter = shape.getOffset()
            objectCenter = object.getOffset()
        }

        return isNotIntersecting(source: object, with: shape, isColliding: isColliding)
        && !isIntersecting(source: object, with: shape, isColliding: isColliding)
        && !isOverlap(source: object, with: shape, isColliding: isColliding)
        && !pointInside(object: object, point: shapeCenter)
        && !pointInside(object: shape, point: objectCenter)
        && !moveReduces(object: object, with: shape, isColliding: isColliding, isOutOfBounds: isOutOfBounds)
    }

    func intersectingBoundaries(source object: Shape, isColliding: Bool) -> Bool {
        var center: Point
        if isColliding {
            center = object.offset
        } else {
            center = object.center
        }
        if (center.xCoord - object.halfLength <= 0)
            || (center.xCoord + object.halfLength >= Constants.screenWidth)
            || (center.yCoord - object.halfLength <= 0)
            || (center.yCoord + object.halfLength >= Constants.screenHeight) {
            return true
        }
        return false
    }

    // Non-Polygon - Non-Polygon Intersection (both do not contain edges)
    private func isOverlap(source object: Shape, with shape: Shape, isColliding: Bool) -> Bool {
        var objectCenter: Point
        let shapeCenter: Point
        if isColliding {
            objectCenter = object.offset
            shapeCenter = shape.offset
        } else {
            objectCenter = object.center
            shapeCenter = shape.center
        }
        let distanceObjectSquared: Double = objectCenter.squareDistance(to: shapeCenter)
        let sumHalfLengthSquared: Double = (object.halfLength + shape.halfLength)
        * (object.halfLength + shape.halfLength)
        return (distanceObjectSquared < sumHalfLengthSquared)
    }

    private func moveReduces(object: Shape, with shape: Shape,
                             isColliding: Bool, isOutOfBounds: Bool) -> Bool {
        guard !isOutOfBounds else {
            return false
        }

        if isColliding && object.center != object.offset {
            if shape.center == shape.offset {
                return moveReducesForSingleOffset(object: object, shape: shape)
            } else {
                return moveReducesForDoubleOffset(object: object, shape: shape)
            }
        }

        return false
    }

    private func moveReducesForSingleOffset(object: Shape, shape: Shape) -> Bool {
        let unitVector = calculateUnitVector(from: object.center, to: object.offset)
        let endPoint = object.center.add(vector: unitVector)
        return calculateNewSquaredDistance(from: endPoint, to: shape.center) < object.center.squareDistance(to: shape.center)
    }

    private func moveReducesForDoubleOffset(object: Shape, shape: Shape) -> Bool {
        let unitVector = calculateUnitVector(from: object.center, to: object.offset)
        let endPoint = object.center.add(vector: unitVector)
        return calculateNewSquaredDistance(from: endPoint, to: shape.offset) < object.center.squareDistance(to: shape.center)
    }

    private func calculateUnitVector(from startPoint: Point, to endPoint: Point) -> Vector {
        var unitVector = (endPoint.subtract(point: startPoint))
        unitVector.scaleToSize(1)
        return unitVector
    }

    private func calculateNewSquaredDistance(from startPoint: Point, to endPoint: Point) -> Double {
        return startPoint.squareDistance(to: endPoint)
    }

    // Polygon - Non-Polygon Intersection (one contains edges)
    private func isIntersecting(source object: Shape, with shape: Shape, isColliding: Bool) -> Bool {
        var edges: [Line] = []
        if !object.edges.isEmpty {
            edges = object.edges
        } else if !shape.edges.isEmpty {
            edges = shape.edges
        } else {
            return false
        }

        return checkEdgePointIntersection(edges: edges, source: object, with: shape, isColliding: isColliding)
    }

    private func checkEdgePointIntersection(edges: [Line], source object: Shape,
                                            with shape: Shape, isColliding: Bool) -> Bool {
        var squaredLength: Double
        var objectCenter: Point

        if !shape.edges.isEmpty {
            squaredLength = object.halfLength * object.halfLength
            if isColliding {
                objectCenter = object.offset
            } else {
                objectCenter = object.center
            }
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

    private func distanceFromPointToLine(point: Point, line: Line) -> Double {
        line.distanceFromPointToLine(point: point)
    }

    // Polygon - Polygon Intersection (both contains edges)
    private func isNotIntersecting(source object: Shape, with shape: Shape, isColliding: Bool) -> Bool {
        var edges: [Line] = []
        var objectEdges: [Line] = []

        if !object.edges.isEmpty && !shape.edges.isEmpty {
            edges = object.edges
            objectEdges = shape.edges
        } else {
            return true
        }

        for edge in edges {
            for objectEdge in objectEdges where linesIntersect(line1: edge, line2: objectEdge) {
                return false
            }
        }

        guard edges.count >= 2 && objectEdges.count >= 2 else {
            return false
        }

        guard edges[0].end.xCoord < objectEdges[1].start.xCoord
                && edges[1].start.xCoord > objectEdges[0].end.xCoord
                && edges[0].end.yCoord < objectEdges[1].start.yCoord
                && edges[1].start.yCoord > objectEdges[0].end.yCoord else {
            return true
        }
        return false
    }

    private func checkStartEndIntersect(_ point1: Point, _ point2: Point, _ point3: Point) -> Bool {
        (point3.yCoord - point1.yCoord) * (point2.xCoord - point1.xCoord) >
        (point2.yCoord - point1.yCoord) * (point3.xCoord - point1.xCoord)
    }

    private func linesIntersect(line1: Line, line2: Line) -> Bool {
        checkStartEndIntersect(line1.start, line2.start, line2.end) !=
        checkStartEndIntersect(line1.end, line2.start, line2.end) &&
        checkStartEndIntersect(line1.start, line1.end, line2.start) !=
        checkStartEndIntersect(line1.start, line1.end, line2.end)
    }

    private func pointOnLine(point: Point, line: Line) -> Bool {
        (point.xCoord >= min(line.start.xCoord, line.end.xCoord) &&
         point.xCoord <= max(line.start.xCoord, line.end.xCoord)) &&
        (point.yCoord >= min(line.start.yCoord, line.end.yCoord) &&
         point.yCoord <= max(line.start.yCoord, line.end.yCoord))
    }

    // Object inside of another object check
    private func pointInside(object: Shape, point: CGPoint) -> Bool {
        guard !object.vertices.isEmpty else {
            return false
        }
        let vertices = object.vertices
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
