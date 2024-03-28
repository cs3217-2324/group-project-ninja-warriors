//
//  JoystickControl.swift
//  NinjaWarriors
//
//  Created by proglab on 22/3/24.
//

import Foundation

class JoystickControl: GameControl {
    internal var inputVector: CGVector = .zero
    internal var entityID: EntityID?

    func getInput() -> Vector {
        return Vector(horizontal: inputVector.dx, vertical: inputVector.dy)
    }

    func setInput(_ vector: CGVector, for entityID: EntityID) {
        inputVector = vector
        self.entityID = entityID
    }

    func setInput(_ vector: Vector, for entityID: EntityID) {
        inputVector = CGVector(dx: vector.horizontal, dy: vector.vertical)
        self.entityID = entityID
    }
}
