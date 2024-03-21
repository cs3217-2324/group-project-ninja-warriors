//
//  MatchPublisher.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

final class MatchPublisher: FactoryPublisher {
    typealias Output = [Match]
    typealias Failure = Error

    typealias Item = MatchWrapper
    typealias UpdateClosure = ([MatchWrapper]) -> Void
    typealias ErrorClosure = (Error) -> Void

    var updateClosure: UpdateClosure?
    var errorClosure: ErrorClosure?

    func subscribe(update: @escaping UpdateClosure, error: @escaping ErrorClosure) {
        self.updateClosure = update
        self.errorClosure = error
    }

    func publish(_ update: [MatchWrapper]) {
        updateClosure?(update)
    }

    func publishError(_ error: Error) {
        errorClosure?(error)
    }
}
