//
//  Entity.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

typealias EntityID = String
protocol Entity: AnyObject {
    var id: EntityID { get }

    // Every entity must define the components that it needs to be created with
    func getInitializingComponents() -> [Component]
    func deepCopy() -> Entity
    func wrapper() -> EntityWrapper?
}
