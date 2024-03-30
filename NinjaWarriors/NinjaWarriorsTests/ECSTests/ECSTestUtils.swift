//
//  ECSTestUtils.swift
//  NinjaWarriorsTests
//
//  Created by Jivesh Mohan on 24/3/24.
//

import Foundation
@testable import NinjaWarriors

class TestEntity: Entity {
    var shape: NinjaWarriors.Shape
    var id: NinjaWarriors.EntityID

    init(id: EntityID, shape: Shape) {
        self.id = id
        self.shape = shape
    }

    func getInitializingComponents() -> [NinjaWarriors.Component] {
        let componentA = TestComponentA(id: UUID().uuidString, data: "hello", entity: self)
        let componentB = TestComponentB(id: UUID().uuidString, data: 42, entity: self)
        return [componentA, componentB]
    }

    func wrapper() -> EntityWrapper? {
        return TestEntityWrapper(id: id, shape: shape.wrapper())
    }
}

class TestComponentA: Component {
    var data: String

    init(id: ComponentID, data: String, entity: Entity) {
        self.data = data
        super.init(id: id, entity: entity)
    }
}

class TestComponentB: Component {
    var data: Int

    init(id: ComponentID, data: Int, entity: Entity) {
        self.data = data
        super.init(id: id, entity: entity)
    }
}

class TestEntityWrapper: EntityWrapper {
    override init(id: EntityID, shape: ShapeWrapper) {
        super.init(id: id, shape: shape)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func toEntity() -> Entity? {
        return TestEntity(id: id, shape: shape.toShape())
    }
}

class TestSystemA: System {
    unowned var manager: EntityComponentManager?
    var state: String = ""

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let components = manager?.components
        components?.forEach { updateComponent($0) }
    }

    private func updateComponent(_ component: Component) {
        if let componentA = component as? TestComponentA {
            state = state.appending(componentA.data)
        }
    }
}

class TestSystemB: System {
    unowned var manager: EntityComponentManager?
    var state: Int = 0

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) {
        let components = manager?.components
        components?.forEach { updateComponent($0) }
    }

    private func updateComponent(_ component: Component) {
        if let componentB = component as? TestComponentB {
            state += componentB.data
        }
    }
}
