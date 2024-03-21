//
//  Listener.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation

protocol Listener {
    associatedtype PublisherType: FactoryPublisher
    var publisher: PublisherType { get }
    func startListening() /*async throws*/
    func stopListening()
}
