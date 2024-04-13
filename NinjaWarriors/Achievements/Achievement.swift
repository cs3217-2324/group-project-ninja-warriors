//
//  Achievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

protocol Achievement {
    var title: String { get }
    var description: String { get }
    var imageAsset: String { get }
    var isRepeatable: Bool { get }
    var count: Int { get set }
}
