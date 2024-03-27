//
//  Entity.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

typealias EntityID = String
protocol Entity: AnyObject {
    // TODO: Remove shape from entity, just have shape in collider
    var shape: Shape { get set }
    var id: EntityID { get }

    // Every entity must define the components that it needs to be created with
    func getInitializingComponents() -> [Component]
    func wrapper() -> EntityWrapper?
}
