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
    /*
    func subscribe(_ receiveValue: @escaping (Output) -> Void,
                   _ receiveCompletion: @escaping (Result<(), Failure>) -> Void)
    */
}
