//
//  Entity.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

typealias EntityID = String
// TODO: check whether better to use a class or a protocol or a struct
protocol Entity: AnyObject {
    var gameObject: GameObject { get set }
    var id: EntityID { get }

    // Every entity must define the components that it needs to be created with
    func getInitializingComponents() -> [Component]
}
