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

        /*
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
                } else {
                    print("set colliders to false")
                    collider.isColliding = false
                    otherCollider.isColliding = false
                    // TODO: Clear rigid body collider as well once 1-1 mapping has been implemented
                }
            }
        }
        */

        for collider in colliders {
            var isSafeToInsert = true

            for otherCollider in colliders where otherCollider != collider {
                if !checkSafeToInsert(source: collider.colliderShape, with: otherCollider.colliderShape, isColliding: collider.isColliding) {
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

                    // Since at least one collider is colliding, set the flag to false
                    isSafeToInsert = false
                    break // Exit the loop early if a collision is detected
                }
            }

            // TODO: Tidy up
            if intersectingBoundaries(source: collider.colliderShape, isColliding: collider.isColliding) {
                collider.isColliding = true
            } else {
                print("set to false!")
                collider.isColliding = false
                collider.colliderShape.resetOffset()
            }

            /*
            if isSafeToInsert && !intersectingBoundaries(source: collider.colliderShape, isColliding: collider.isColliding) {
                //print("Set collider \(collider) to false")
                collider.isColliding = false
                collider.colliderShape.resetOffset()
                // TODO: Clear rigid body collider as well once 1-1 mapping has been implemented
            }
            */
        }



    }

    func checkSafeToInsert(source object: Shape, with shape: Shape, isColliding: Bool) -> Bool {
        /*
        print("collision", isNotIntersecting(source: object, with: shape),
              !isIntersecting(source: object, with: shape),
              !isOverlap(source: object, with: shape),
              !pointInside(object: object, point: shape.getCenter()),
              !pointInside(object: shape, point: object.getCenter()))
        */
        var shapeCenter: CGPoint
        var objectCenter: CGPoint
        // TODO: TBC
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
        // TODO: TBC
        /*
        && !pointInside(object: object, point: shapeCenter, isColliding: isColliding)
        && !pointInside(object: shape, point: objectCenter, isColliding: isColliding)
        */
    }

    func intersectingBoundaries(source object: Shape, isColliding: Bool) -> Bool {
        var center: Point
        if isColliding {
            print("using offset", object.offset)
            center = object.offset
        } else {
            center = object.center
        }
        if (center.xCoord - object.halfLength <= 0)
            || (center.xCoord + object.halfLength >= Constants.screenWidth)
            || (center.yCoord - object.halfLength <= 0)
            || (center.yCoord + object.halfLength >= Constants.screenHeight) {
            print("intersecting boundaries")
            return true
        }
        print("not anymore")
        return false
    }

    // Non-Polygon - Non-Polygon Intersection (both do not contain edges)
    private func isOverlap(source object: Shape, with shape: Shape, isColliding: Bool) -> Bool {
        var objectCenter: Point
        var shapeCenter: Point = shape.center
        if isColliding {
            objectCenter = object.offset
        } else {
            objectCenter = object.center
        }
        let distanceObjectSquared: Double = objectCenter.squareDistance(to: shapeCenter)
        let sumHalfLengthSquared: Double = (object.halfLength + shape.halfLength)
        * (object.halfLength + shape.halfLength)
        return distanceObjectSquared < sumHalfLengthSquared
    }

    // Polygon - Non-Polygon Intersection (one contains edges)
    private func isIntersecting(source object: Shape, with shape: Shape, isColliding: Bool) -> Bool {
        guard let edges = shape.edges ?? object.edges else {
            return false
        }
        return checkEdgePointIntersection(edges: edges, source: object, with: shape, isColliding: isColliding)
    }

    // TODO: TBC on isColliding and setting of centers
    private func checkEdgePointIntersection(edges: [Line], source object: Shape,
                                            with shape: Shape, isColliding: Bool) -> Bool {
        var squaredLength: Double
        var objectCenter: Point

        if shape.edges != nil {
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
