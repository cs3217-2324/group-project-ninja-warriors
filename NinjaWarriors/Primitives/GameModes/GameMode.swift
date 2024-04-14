//
//  GameMode.swift
//  NinjaWarriors
//
//  Created by proglab on 14/4/24.
//

import Foundation

protocol GameMode {
    func isGameOver(for gameWorld: GameWorld) -> Bool
}
