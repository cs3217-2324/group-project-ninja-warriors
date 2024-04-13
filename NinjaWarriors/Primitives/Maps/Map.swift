//
//  Map.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

protocol Map {
    var mapBackground: String { get }
    var mapEntities: [Entity] { get set }
    func getPositions() -> [Point]
    func getMapEntities() -> [Entity]
}
