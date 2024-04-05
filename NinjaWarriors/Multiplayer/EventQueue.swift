//
//  EventQueue.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 5/4/24.
//

import Foundation

class EventQueue {
    private let queue: DispatchQueue

    init(label: String) {
        self.queue = DispatchQueue(label: label)
    }

    func async(execute work: @escaping () -> Void) {
        queue.async {
            work()
        }
    }

    func sync<T>(execute work: () throws -> T) rethrows -> T {
        return try queue.sync {
            try work()
        }
    }

    func suspend() {
        queue.suspend()
    }

    func resume() {
        queue.resume()
    }

    func barrierAsync(execute work: @escaping () -> Void) {
        queue.async(flags: .barrier) {
            work()
        }
    }
}
