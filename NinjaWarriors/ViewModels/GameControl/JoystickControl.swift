//
//  JoystickControl.swift
//  NinjaWarriors
//
//  Created by proglab on 22/3/24.
//

import Foundation

class JoystickControl: GameControl {
    internal var inputVector: CGVector = .zero

    func getInputVector() -> CGVector {
        inputVector
    }

    func setInputVector(_ vector: CGVector) {
        inputVector = vector
    }

    init() {}
}
