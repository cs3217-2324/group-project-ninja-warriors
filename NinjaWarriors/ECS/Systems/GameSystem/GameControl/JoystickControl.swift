//
//  JoystickControl.swift
//  NinjaWarriors
//
//  Created by proglab on 22/3/24.
//

import Foundation

class JoystickControl: GameControl {
    internal var inputVector: CGVector = .zero
    internal var entity: Entity?

    func getInput() -> Vector {
        return Vector(horizontal: inputVector.dx, vertical: inputVector.dy)
    }

    func setInput(_ vector: CGVector, for entity: Entity) {
        inputVector = vector
        self.entity = entity
    }

    func setInput(_ vector: Vector, for entity: Entity) {
        inputVector = CGVector(dx: vector.horizontal, dy: vector.vertical)
        self.entity = entity
    }
}
