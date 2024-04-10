//
//  Rules.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 10/4/24.
//

import Foundation

protocol Rules {
    var manager: EntityComponentManager { get set }
    var deltaTime: TimeInterval { get }

    func performRule()
}
