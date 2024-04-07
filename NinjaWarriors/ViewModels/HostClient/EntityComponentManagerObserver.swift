//
//  EntityComponentManagerObserver.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 7/4/24.
//

import Foundation

protocol EntityComponentManagerObserver: AnyObject {
    func entityComponentManagerDidUpdate()
}
