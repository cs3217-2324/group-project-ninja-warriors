//
//  PhysicsElasticCollision.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol PhysicsElasticCollision {
    func doElasticCollision(collider: inout PhysicsBody, collidee: inout PhysicsBody)
}
