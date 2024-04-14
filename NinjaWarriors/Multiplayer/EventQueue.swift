//
//  EventQueue.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 5/4/24.
//

import Foundation

class EventQueue {
    private var queue: DispatchQueue
    var deletedEntities: Set<EntityID> = []
    var components: Set<Component> = []

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

    func contains(_ entity: Entity) -> Bool {
        deletedEntities.contains(entity.id)
    }

    func process(_ entity: Entity) {
        deletedEntities.insert(entity.id)
    }

    func process(_ entityId: String) {
        deletedEntities.insert(entityId)
    }

    func hasComponents() -> Bool {
        !components.isEmpty
    }

    func containsComponent(_ component: Component) -> Bool {
        components.contains(component)
    }

    func addComponent(_ component: Component) {
        components.insert(component)
    }

    func processComponent() -> Component? {
        guard !components.isEmpty else {
            return nil
        }
        return components.removeFirst()
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
