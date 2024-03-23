//
//  GameControl.swift
//  NinjaWarriors
//
//  Created by proglab on 22/3/24.
//

import Foundation

protocol GameControl {
    var inputVector: CGVector { get }
    func getInputVector() -> CGVector
    func setInputVector(_ vector: CGVector)
}
