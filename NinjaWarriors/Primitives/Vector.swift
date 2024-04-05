//
//  Vector.swift
//  CollisionHandler
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation

struct Vector {
    static let zero = Vector(horizontal: 0, vertical: 0)

    private(set) var horizontal: Double
    private(set) var vertical: Double

    init(horizontal: Double, vertical: Double) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    init(_ vector: CGVector) {
        horizontal = vector.dx
        vertical = vector.dy
    }

    mutating func setVectorCoord(horizontal: Double, vertical: Double) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    func squareLength() -> Double {
        self.horizontal * self.horizontal + self.vertical * self.vertical
    }

    func getLength() -> Double {
        sqrt(squareLength())
    }

    func add(vector: Vector) -> Vector {
        Vector(horizontal: self.horizontal + vector.horizontal, vertical: self.vertical + vector.vertical)
    }

    func add(_ magnitude: Double) -> Vector {
        Vector(horizontal: self.horizontal + magnitude, vertical: self.vertical + magnitude)
    }

    func subtract(vector: Vector) -> Vector {
        Vector(horizontal: self.horizontal - vector.horizontal, vertical: self.vertical - vector.vertical)
    }

    func scale(_ magnitude: Double) -> Vector {
        Vector(horizontal: self.horizontal * magnitude, vertical: self.vertical * magnitude)
    }

    mutating func scaleToSize(_ size: Double) {
        let normVector: Vector = normalize()
        self.horizontal = normVector.horizontal * size
        self.vertical = normVector.vertical * size
    }

    func dotProduct(with vector: Vector) -> Double {
        self.horizontal * vector.horizontal + self.vertical * vector.vertical
    }

    func crossProduct(with vector: Vector) -> Double {
        self.horizontal * vector.vertical - vector.horizontal * self.vertical
    }

    func rayTracingProduct(with vector: Vector) -> Double {
        self.horizontal * vector.vertical + vector.horizontal * self.vertical
    }

    func getComplement() -> Vector {
        Vector(horizontal: -self.horizontal, vertical: -self.vertical)
    }

    func getPerpendicularVector() -> Vector {
        Vector(horizontal: -self.vertical, vertical: self.horizontal)
    }

    func normalize() -> Vector {
        Vector(horizontal: horizontal / getLength(), vertical: vertical / getLength())
    }

    mutating func changeHorizontalDir() {
        self.horizontal = -self.horizontal
    }

    mutating func changeVerticalDir() {
        self.vertical = -self.vertical
    }

    func calcUnitVector() -> Vector? {
        let magnitude: Double = sqrt(squareLength())
        guard magnitude > 0 else {
            return nil
        }
        return Vector(horizontal: horizontal / magnitude, vertical: vertical / magnitude)
    }

    func getAngleInRadians(with vector: Vector) -> Double {
        let crossProduct = crossProduct(with: vector)
        let dotProduct = dotProduct(with: vector)
        return atan2(crossProduct, dotProduct)
    }

    func wrapper() -> VectorWrapper {
        VectorWrapper(horizontal: horizontal, vertical: vertical)
    }
}

extension Vector: Equatable {
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.horizontal == rhs.horizontal && lhs.vertical == rhs.vertical
    }
}

extension Vector {
    mutating func updateAttributes(_ newVector: Vector) {
        self.horizontal = newVector.horizontal
        self.vertical = newVector.vertical
    }
}
