//
//  Map.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 11/4/24.
//

import Foundation

protocol Map {
    var manager: RealTimeManagerAdapter { get set }
    var fixedEntities: [Entity] { get set }
    func getPositions() -> [Point]
    func populateFixedEntities()
    func addEntities()
    func startMap()
}
