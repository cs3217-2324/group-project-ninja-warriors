//
//  FactoryPublisher.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

/*
protocol FactoryPublisher {
    typealias UpdateClosure = ([FactoryWrapper]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure? { get set }
    var errorClosure: ErrorClosure? { get set }

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure)
    func publish(_ update: [FactoryWrapper])
    func publishError(_ error: Error)
}
*/


protocol FactoryPublisher {
    associatedtype T: Decodable
    typealias UpdateClosure = ([T]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure? { get set }
    var errorClosure: ErrorClosure? { get set }

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure)
    func publish(_ update: [T])
    func publishError(_ error: Error)
}
