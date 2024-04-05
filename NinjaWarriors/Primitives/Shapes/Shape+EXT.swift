//
//  Shape+EXT.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 17/3/24.
//

import Foundation

// MARK: API Calls
extension Shape {
    func withHalfLength(_ halfLength: Double) -> Shape {
        self.halfLength = halfLength
        return self
    }

    func withCenter(xCoord: Double, yCoord: Double) -> Shape {
        center.setCartesian(xCoord: xCoord, yCoord: yCoord)
        return self
    }

    func withOrientation(_ orientation: Double) -> Shape {
        self.orientation = orientation
        return self
    }

    func withEdges(_ edges: [Line]) -> Shape {
        self.edges = edges
        return self
    }

    func withVertices(_ vertices: [Point]) -> Shape {
        self.vertices = vertices
        return self
    }
}
