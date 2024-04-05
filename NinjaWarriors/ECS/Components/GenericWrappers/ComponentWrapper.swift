//
//  ComponentWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 21/3/24.
//

import Foundation

protocol ComponentWrapper: Codable {
    func toComponent(entity: Entity) -> (Component, Entity)?
}
