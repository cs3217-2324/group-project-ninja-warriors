//
//  LinkedList.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/4/24.
//

import Foundation

class LinkedList<T: Equatable> {
    private var head: Node<T>?
    private var tail: Node<T>?

    var isEmpty: Bool {
        return head == nil
    }

    func append(value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }

    func removeFirst() -> T? {
        guard let currentHead = head else { return nil }
        head = currentHead.next
        if head == nil {
            tail = nil
        }
        return currentHead.value
    }

    func removeAll() {
        head = nil
        tail = nil
    }

    func contains(value: T) -> Bool {
        var currentNode = head
        while let node = currentNode {
            if node.value == value {
                return true
            }
            currentNode = node.next
        }
        return false
    }
}
