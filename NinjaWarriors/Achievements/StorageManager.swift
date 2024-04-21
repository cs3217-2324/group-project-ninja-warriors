//
//  StorageManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

protocol StorageManager {
    func save<T: Codable>(_ object: T)
    func load<T: Decodable>() -> T?
}
