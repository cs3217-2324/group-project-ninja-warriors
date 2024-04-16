//
//  Node.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/4/24.
//

import Foundation

class Node<T: Equatable> {
    var value: T
    var next: Node<T>?

    init(value: T) {
        self.value = value
    }
}
