//
//  CollisionDetector.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

struct CollisionDetector {
    func checkSafeToInsert(source object: GameObject, with gameObject: GameObject) -> Bool {
        isNotIntersecting(source: object, with: gameObject)
        && !isIntersecting(source: object, with: gameObject)
        && !isOverlap(source: object, with: gameObject)
        && !pointInside(object: object, point: gameObject.getCenter())
        && !pointInside(object: gameObject, point: object.getCenter())
    }

    // Non-Polygon - Non-Polygon Intersection (both do not contain edges)
    func isOverlap(source object: GameObject, with gameObject: GameObject) -> Bool {
        let distanceObjectSquared: Double = object.center.squareDistance(to: gameObject.center)
        let sumHalfLengthSquared: Double = (object.halfLength + gameObject.halfLength)
        * (object.halfLength + gameObject.halfLength)
        return distanceObjectSquared > sumHalfLengthSquared
    }

    // Polygon - Non-Polygon Intersection (one contains edges)
    func isIntersecting(source object: GameObject, with gameObject: GameObject) -> Bool {
        guard let edges = gameObject.edges ?? object.edges else {
            return false
        }
        return checkEdgePointIntersection(edges: edges, source: object, with: gameObject)
    }

    func checkEdgePointIntersection(edges: [Line], source object: GameObject, with gameObject: GameObject) -> Bool {
        var squaredLength: Double
        var objectCenter: Point

        if let _ = gameObject.edges {
            squaredLength = object.halfLength * object.halfLength
            objectCenter = object.center
        } else {
            squaredLength = gameObject.halfLength * gameObject.halfLength
            objectCenter = gameObject.center
        }

        for edge in edges {
            guard objectCenter.squareDistance(to: edge.start) >= squaredLength else {
                return true
            }
            guard distanceFromPointToLine(point: objectCenter, line: edge) >= gameObject.halfLength else {
                return true
            }
        }
        return false
    }

    func distanceFromPointToLine(point: Point, line: Line) -> Double {
        line.distanceFromPointToLine(point: point)
    }

    // Polygon - Polygon Intersection (both contains edges)
    func isNotIntersecting(source object: GameObject, with gameObject: GameObject) -> Bool {
        guard let edges = object.edges, let objectEdges = gameObject.edges else {
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
    func pointInside(object: GameObject, point: CGPoint) -> Bool {
        guard let vertices = object.vertices else {
            return false
        }
        let nvert: Int = object.countVetices()
        var isPointInside = false
        var j = nvert - 1

        for i in 0..<nvert {
            let isVertexPointYDiff = (vertices[i].yCoord <= point.y) != (vertices[j].yCoord <= point.y)
            let xDiff = (vertices[j].xCoord - vertices[i].xCoord)
            let pointVertexYDiff = (point.y - vertices[i].yCoord)
            let vertexVertexYDiff = (vertices[j].yCoord - vertices[i].yCoord)

            if (isVertexPointYDiff)
                && (point.x <= xDiff * pointVertexYDiff / vertexVertexYDiff + vertices[i].xCoord) {
                isPointInside.toggle()
            }
            j = i
        }
        return isPointInside
    }
}
