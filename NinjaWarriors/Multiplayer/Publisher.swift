//
//  Publisher.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol Publisher {
    associatedtype Output
    associatedtype Failure: Error
}
