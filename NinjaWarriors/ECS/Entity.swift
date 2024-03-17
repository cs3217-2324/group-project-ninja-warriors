//
//  Entity.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 17/3/24.
//

import Foundation

//TODO: check whether better to use a class or a protocol or a struct
protocol Entity: AnyObject {
    var id: UUID { get }
}
