//
//  SystemManagerTests.swift
//  NinjaWarriorsTests
//
//  Created by Jivesh Mohan on 24/3/24.
//

import XCTest
@testable import NinjaWarriors

final class SystemManagerTests: XCTestCase {
    func initEntityComponentManager() -> EntityComponentManager {
        let manager = EntityComponentManager()
        let entity = TestEntity(id: "test", shape: Shape(center: Point(xCoord: 0, yCoord: 0), halfLength: 5))
        manager.add(entity: entity)
        return manager
    }

    func test_addSystemToManager_systemAdded() {
        let manager = SystemManager()
        let ecManager = initEntityComponentManager()
        let system = TestSystemA(for: ecManager)
        manager.add(system: system)

        XCTAssertNotNil(manager.system(ofType: TestSystemA.self))
    }

    func test_systemUpdate() {
        let manager = SystemManager()
        let ecManager = initEntityComponentManager()
        let system = TestSystemA(for: ecManager)
        manager.add(system: system)

        manager.update(after: 20)

        XCTAssert(system.state != "")
    }
}
