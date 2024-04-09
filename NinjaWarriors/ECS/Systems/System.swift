//
//  System.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

protocol System: AnyObject {
    var manager: EntityComponentManager { get set }

    init(for manager: EntityComponentManager)
    func update(after time: TimeInterval)
}
