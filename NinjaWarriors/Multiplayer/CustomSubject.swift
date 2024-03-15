//
//  CustomSubject.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

// Custom subject similar to PassthroughSubject in Combine
class CustomSubject<Output, Failure: Error>: Publisher {
    private var valueHandler: ((Output) -> Void)?
    private var completionHandler: ((Result<(), Failure>) -> Void)?

    func send(_ value: Output) {
        valueHandler?(value)
    }

    func send(completion: Result<(), Failure>) {
        completionHandler?(completion)
    }

    func subscribe(_ receiveValue: @escaping (Output) -> Void, _ receiveCompletion: @escaping (Result<(), Failure>) -> Void) {
        valueHandler = receiveValue
        completionHandler = receiveCompletion
    }
}
