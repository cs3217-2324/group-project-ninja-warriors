//
//  EntityComponentManagerTests.swift
//  NinjaWarriorsTests
//
//  Created by Jivesh Mohan on 24/3/24.
//

import XCTest
@testable import NinjaWarriors

final class EntityComponentManagerTests: XCTestCase {
    func test_addEntityToManager_entityAdded() {
        let manager = EntityComponentManager(for: "test")
        let entity = TestEntity(id: "test", shape: Shape(center: Point(xCoord: 0, yCoord: 0), halfLength: 5))
        manager.add(entity: entity)

        XCTAssertEqual(manager.entityMap.keys.count, 1)
        XCTAssert(manager.contains(entity: entity))
        XCTAssert(manager.contains(entityID: entity.id))
    }

    func test_addEntityToManager_componentsAdded() {
        let manager = EntityComponentManager(for: "test")
        let entity = TestEntity(id: "test", shape: Shape(center: Point(xCoord: 0, yCoord: 0), halfLength: 5))
        manager.add(entity: entity)

        let componentA = manager.getComponent(ofType: TestComponentA.self, for: entity)
        let componentB = manager.getComponent(ofType: TestComponentB.self, for: entity)

        XCTAssertNotNil(componentA)
        XCTAssertNotNil(componentB)
    }

    func test_removeEntityFromManager_entityRemoved() {
        let manager = EntityComponentManager(for: "test")
        let entity = TestEntity(id: "test", shape: Shape(center: Point(xCoord: 0, yCoord: 0), halfLength: 5))
        manager.add(entity: entity)

        manager.remove(entity: entity)

        XCTAssertEqual(manager.entityMap.keys.count, 0)
        XCTAssertFalse(manager.contains(entity: entity))
        XCTAssertFalse(manager.contains(entityID: entity.id))
    }

    func test_removeEntityFromManager_componentsRemoved() {
        let manager = EntityComponentManager(for: "test")
        let entity = TestEntity(id: "test", shape: Shape(center: Point(xCoord: 0, yCoord: 0), halfLength: 5))
        manager.add(entity: entity)

        manager.remove(entity: entity)

        let componentA = manager.getComponent(ofType: TestComponentA.self, for: entity)
        let componentB = manager.getComponent(ofType: TestComponentB.self, for: entity)

        XCTAssertNil(componentA)
        XCTAssertNil(componentB)
    }
}
