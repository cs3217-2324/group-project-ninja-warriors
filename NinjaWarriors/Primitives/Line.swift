//
//  Line.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

struct Line {
    private(set) var start = Point(xCoord: 0.0, yCoord: 0.0)
    private(set) var end = Point(xCoord: 0.0, yCoord: 0.0)
    private(set) var vector = Vector(horizontal: 0.0, vertical: 0.0)

    init(start: Point, end: Point) {
        self.start = start
        self.end = end
        self.vector = getLineVector()
    }

    init(start: Point, vector: Vector) {
        self.start = start
        self.vector = vector
        self.end = calculateEndPoint()
    }

    init(vector: Vector, distance: Double, middle: Point) {
        self.vector = vector
        calcStartEndFromMiddle(middle: middle, distance: distance)
    }

    init(start: Point, vector: Vector, maxDistance: Double) {
        self.start = start
        self.vector = vector
        self.end = calculateEndPoint(maxDistance: maxDistance)
    }

    init(end: Point, vector: Vector, maxDistance: Double) {
        self.end = end
        self.vector = vector
        self.start = calculateStartPoint(maxDistance: maxDistance)
    }

    var squaredLength: Double {
        start.squareDistance(to: end)
    }

    var length: Double {
        sqrt(squaredLength)
    }

    func squaredDistance(_ distance: Double) -> Double {
        distance * distance
    }

    func calculateEndPoint(maxDistance: Double = Constants.screenHeight) -> Point {
        let normalizedVector = vector.normalize()
        var endPointX = start.xCoord + normalizedVector.horizontal * maxDistance
        var endPointY = start.yCoord + normalizedVector.vertical * maxDistance
        if endPointX < 0 {
            endPointX = 0
            endPointY = recalculateEndPoint(normalizedVector)
        }
        return Point(xCoord: endPointX, yCoord: endPointY)
    }

    func calculateStartPoint(maxDistance: Double = Constants.screenHeight) -> Point {
        let normalizedVector = vector.normalize()
        let startPointX = end.xCoord - normalizedVector.horizontal * maxDistance
        let startPointY = end.yCoord - normalizedVector.vertical * maxDistance
        return Point(xCoord: startPointX, yCoord: startPointY)
    }

    func recalculateEndPoint(_ vector: Vector) -> Double {
        start.yCoord - (start.xCoord / vector.horizontal) * vector.vertical
    }

    mutating func calcStartEndFromMiddle(middle: Point, distance: Double) {
        let normalizedVector = vector.normalize()
        let displacementX = normalizedVector.horizontal * (distance / 2)
        let displacementY = normalizedVector.vertical * (distance / 2)
        start = Point(xCoord: middle.xCoord - displacementX, yCoord: middle.yCoord - displacementY)
        end = Point(xCoord: middle.xCoord + displacementX, yCoord: middle.yCoord + displacementY)
    }

    func squaredDistanceFromPointToLine(point: Point) -> Double {
        let yDistance = end.yCoord - start.yCoord
        let xDistance = end.xCoord - start.xCoord
        let endStartDistanceX = end.xCoord * start.yCoord
        let endStartDistanceY = end.yCoord * start.xCoord
        let numerator = yDistance * point.xCoord - xDistance * point.yCoord + endStartDistanceX - endStartDistanceY
        let squaredNumerator = squaredDistance(numerator)
        let squaredLength = squaredDistance(xDistance) + squaredDistance(yDistance)
        return squaredNumerator / squaredLength
    }

    func getLineVector() -> Vector {
        end.subtract(point: start)
    }

    func getPerpendicularVector() -> Vector {
        getLineVector().getPerpendicularVector()
    }

    func rescale(magnitude: Double) -> Line {
        let scaleVector: Vector = getLineVector().scale(magnitude)
        return Line(end: end, vector: scaleVector, maxDistance: scaleVector.getLength())
    }

    func getLinePointVector(point: Point) -> Vector {
        point.subtract(point: start)
    }

    func distanceFromPointToLine(point: Point) -> Double {
        let lineVector = getLineVector()
        let pointVector = getLinePointVector(point: point)

        guard length != 0 else {
            return handleZeroLineLength()
        }
        let projection = calculateProjection(pointVector: pointVector, lineVector: lineVector)
        if projection < 0 {
            return distanceToPoint(point: point, from: start)
        } else if projection > length {
            return distanceToPoint(point: point, from: end)
        }
        return calculatePerpendicularDistance(pointVector: pointVector, lineVector: lineVector)
    }

    func calculateVectorLength(vector: Vector) -> Double {
        sqrt((vector.horizontal * vector.horizontal) + (vector.vertical * vector.vertical))
    }

    func handleZeroLineLength() -> Double {
        -1
    }

    func calculateProjection(pointVector: Vector, lineVector: Vector) -> Double {
        ((pointVector.horizontal * lineVector.horizontal) + (pointVector.vertical * lineVector.vertical)) / length
    }

    func distanceToPoint(point: Point, from start: Point) -> Double {
        sqrt((point.xCoord - start.xCoord) *
             (point.xCoord - start.xCoord) +
             (point.yCoord - start.yCoord) *
             (point.yCoord - start.yCoord))
    }

    func calculatePerpendicularDistance(pointVector: Vector, lineVector: Vector) -> Double {
        abs((pointVector.horizontal * lineVector.vertical - pointVector.vertical * lineVector.horizontal) / length)
    }

    func isPointNearLine(point: Point, range: Double) -> Bool {
        let squaredDistanceToLine = squaredDistanceFromPointToLine(point: point)
        return squaredDistanceToLine <= range
    }

    func minimumDistanceFromPointSquared(_ point: Point) -> Double {
        let firstVector = start.subtract(point: point)
        let secondVector = end.subtract(point: point)
        let crossProduct = firstVector.crossProduct(with: secondVector)
        let minimumDistanceFromCircleToLineSquared = (crossProduct * crossProduct) / squaredLength
        return minimumDistanceFromCircleToLineSquared
    }

    func projectionOfPointOntoLineIsOnLine(_ point: Point) -> Bool {
        let startVector = start.subtract(point: point)
        let endVector = end.subtract(point: point)
        let startToEnd = end.subtract(point: start)

        let startDotProduct = startVector.dotProduct(with: startToEnd)
        let endDotProduct = endVector.dotProduct(with: startToEnd)

        return startDotProduct < 0 && endDotProduct < 0
    }

    func pointsLieOnSameSide(_ start: Point, _ end: Point) -> Bool {
        let firstCrossProduct = self.end.subtract(point: self.start)
            .crossProduct(with: start.subtract(point: self.start))

        let secondCrossProduct = self.end.subtract(point: self.start)
            .crossProduct(with: end.subtract(point: self.start))

        return firstCrossProduct * secondCrossProduct >= 0
    }

    func wrapper() -> LineWrapper {
        LineWrapper(start: start.wrapper(),
                    end: end.wrapper(),
                    vector: vector.wrapper())
    }
}

extension Line: Equatable {
    static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.start == rhs.start
        && lhs.end == rhs.end
        && lhs.vector == rhs.vector
    }
}
