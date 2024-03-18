//
//  GameObject+EXT.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 17/3/24.
//

import Foundation

// MARK: API Calls
extension GameObject {
    func withHalfLength(_ halfLength: Double) -> GameObject {
        self.halfLength = halfLength
        return self
    }

    func withCenter(xCoord: Double, yCoord: Double) -> GameObject {
        self.center.setCartesian(xCoord: xCoord, yCoord: yCoord)
        return self
    }

    func withOrientation(_ orientation: Double) -> GameObject {
        self.orientation = orientation
        return self
    }

    func withEdges(_ edges: [Line]) -> GameObject {
        self.edges = edges
        return self
    }

    func withVertices(_ vertices: [Point]) -> GameObject {
        self.vertices = vertices
        return self
    }
}

