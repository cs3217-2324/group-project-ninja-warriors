//
//  FactoryPublisher.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol FactoryPublisher: Publisher {
    associatedtype Item: Decodable
    typealias UpdateClosure = ([Item]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure? { get set }
    var errorClosure: ErrorClosure? { get set }

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure)
    func publish(_ update: [Item])
    func publishError(_ error: Error)
}
