//
//  PrimitiveTests.swift
//  NinjaWarriorsTests
//
//  Created by Muhammad Reyaaz on 23/3/24.
//

import XCTest
@testable import NinjaWarriors

final class PrimitiveTests: XCTestCase {

    // MARK: Point
    func test_addVectorToPoint_equalNewPoint() {
        _ = Line(start: Point(xCoord: 0, yCoord: 0), end: Point(xCoord: 3, yCoord: 4))
        let startPoint = Point(xCoord: 1.0, yCoord: 1.0)
        let shiftVector = Vector(horizontal: 1.0, vertical: 1.0)

        let expectedEndPoint = Point(xCoord: 2.0, yCoord: 2.0)

        let actualEndPoint: Point = startPoint.add(vector: shiftVector)

        XCTAssertEqual(actualEndPoint, expectedEndPoint)
    }

    func test_subtractVectorFromPoint_equalNewPoint() {
        let startPoint = Point(xCoord: 2.0, yCoord: 2.0)
        let shiftVector = Vector(horizontal: 1.0, vertical: 1.0)

        let expectedEndPoint = Point(xCoord: 1.0, yCoord: 1.0)

        let actualEndPoint: Point = startPoint.subtract(vector: shiftVector)

        XCTAssertEqual(actualEndPoint, expectedEndPoint)
    }

    func test_squareDistance_equalDistance() {
        let startPoint = Point(xCoord: 2.0, yCoord: 2.0)
        let endPoint = Point(xCoord: 4.0, yCoord: 4.0)

        let actualSquaredDistance: Double = startPoint.squareDistance(to: endPoint)

        let expectedSquaredDistance = 8.0

        XCTAssertEqual(actualSquaredDistance, expectedSquaredDistance)
    }

    // MARK: Vector
    func test_squareVectorLength_equalDistance() {
        let vector = Vector(horizontal: 2.0, vertical: 2.0)
        let actualSquaredLength: Double = vector.squareLength()

        let expectedSquaredLength = 8.0

        XCTAssertEqual(actualSquaredLength, expectedSquaredLength)
    }

    func test_addVectors_equalVector() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 2.0)

        let actualVector: Vector = vectorA.add(vector: vectorB)

        let expectedVector = Vector(horizontal: 6.0, vertical: 6.0)

        XCTAssertEqual(actualVector, expectedVector)
    }

    func test_subtractVectors_equalVector() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 2.0)

        let actualVector: Vector = vectorA.subtract(vector: vectorB)

        let expectedVector = Vector(horizontal: 2.0, vertical: 2.0)

        XCTAssertEqual(actualVector, expectedVector)
    }

    func test_scaleVectors_equalVector() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let magnitude = 2.0

        let actualVector: Vector = vectorA.scale(magnitude)

        let expectedVector = Vector(horizontal: 8.0, vertical: 8.0)

        XCTAssertEqual(actualVector, expectedVector)
    }

    func test_dotProductVectors_equalProduct() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 2.0)

        let actualDotProduct: Double = vectorA.dotProduct(with: vectorB)

        let expectedDotProduct = 16.0

        XCTAssertEqual(actualDotProduct, expectedDotProduct)
    }

    func test_crossProduct_equalProduct() {
        let vectorA = Vector(horizontal: 4.0, vertical: 2.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 4.0)

        let actualCrossProduct: Double = vectorA.crossProduct(with: vectorB)

        let expectedCrossProduct = 12.0

        XCTAssertEqual(actualCrossProduct, expectedCrossProduct)
    }

    func test_rayTracingProduct_equalProduct() {
        let vectorA = Vector(horizontal: 4.0, vertical: 2.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 4.0)

        let actualRayTracingProduct: Double = vectorA.rayTracingProduct(with: vectorB)

        let expectedRayTracingProduct = 20.0

        XCTAssertEqual(actualRayTracingProduct, expectedRayTracingProduct)
    }

    // MARK: Line
    func testInitWithStartAndEndPoints() {
        let line = Line(start: Point(xCoord: 0, yCoord: 0), end: Point(xCoord: 3, yCoord: 4))
        XCTAssertEqual(line.start, Point(xCoord: 0, yCoord: 0))
        XCTAssertEqual(line.end, Point(xCoord: 3, yCoord: 4))
        XCTAssertEqual(line.vector, Vector(horizontal: 3, vertical: 4))
    }

    func testInitWithStartPointAndVector() {
        let vector = Vector(horizontal: 3, vertical: 4)
        let line = Line(start: Point(xCoord: 0, yCoord: 0), end: Point(xCoord: 3, yCoord: 4))
        XCTAssertEqual(line.start, Point(xCoord: 0, yCoord: 0))
        XCTAssertEqual(line.vector, vector)
        XCTAssertEqual(line.end, Point(xCoord: 3, yCoord: 4))
    }

    func testSquaredLength() {
        let line = Line(start: Point(xCoord: 0, yCoord: 0), end: Point(xCoord: 3, yCoord: 4))
        XCTAssertEqual(line.squaredLength, 25)
    }

    func testLength() {
        let line = Line(start: Point(xCoord: 0, yCoord: 0), end: Point(xCoord: 3, yCoord: 4))
        XCTAssertEqual(line.length, 5)
    }

    func testCalculateEndPointWithMaxDistance() {
        let line = Line(start: Point(xCoord: 0, yCoord: 0), end: Point(xCoord: 3, yCoord: 4))
        let endPoint = line.calculateEndPoint(maxDistance: 10)
        XCTAssertEqual(endPoint, Point(xCoord: 6, yCoord: 8))
    }
}
