//
//  MainCodable.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 23/3/24.
//

import Foundation

protocol MainCodable: Codable {}

@propertyWrapper
struct AnyMainCodable<T>: Codable, CustomDebugStringConvertible { }
