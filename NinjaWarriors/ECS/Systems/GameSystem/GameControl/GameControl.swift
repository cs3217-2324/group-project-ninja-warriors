//
//  GameControl.swift
//  NinjaWarriors
//
//  Created by proglab on 22/3/24.
//

import Foundation

protocol GameControl {
    var inputVector: CGVector { get }
    var entity: Entity? { get }

    func getInput() -> Vector
    func setInput(_ vector: Vector, for: Entity)
    func setInput(_ vector: CGVector, for: Entity)
}
