//
//  FactoryWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol FactoryWrapper: Codable {
    associatedtype T: Decodable
    func encode(to encoder: Encoder) throws
}
