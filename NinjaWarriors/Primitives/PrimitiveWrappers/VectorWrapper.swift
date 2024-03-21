//
//  VectorWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct VectorWrapper: Codable {
    var horizontal: Double
    var vertical: Double

    func toVector() -> Vector {
        return Vector(horizontal: horizontal, vertical: vertical)
    }
}
