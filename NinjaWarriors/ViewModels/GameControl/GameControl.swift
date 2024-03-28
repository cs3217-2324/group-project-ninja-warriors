//
//  GameControl.swift
//  NinjaWarriors
//
//  Created by proglab on 22/3/24.
//

import Foundation

protocol GameControl {
    var inputVector: CGVector { get }
    var entityID: EntityID? { get }
    func getInput() -> Vector
    // TODO: Change entityID
    func setInput(_ vector: Vector, for: EntityID)
    func setInput(_ vector: CGVector, for: EntityID)
}
