//
//  RealtimeTests.swift
//  NinjaWarriorsTests
//
//  Created by Muhammad Reyaaz on 23/3/24.
//

import XCTest
import Foundation
import FirebaseDatabase
@testable import NinjaWarriors

final class RealTimeManagerAdapterTests: XCTestCase {

    var realTimeManagerAdapter: RealTimeManagerAdapter?

    override func setUpWithError() throws {
        try super.setUpWithError()
        realTimeManagerAdapter = RealTimeManagerAdapter(matchId: "0QkhbxGv8ZdrZxNMukr6")
    }

    override func tearDownWithError() throws {
        realTimeManagerAdapter = nil
        try super.tearDownWithError()
    }

    func testGetAllEntities() async throws {
        let entities = try await realTimeManagerAdapter?.getAllEntities()
        XCTAssertNotNil(entities)
    }

    func testGetEntityById() async throws {
        let entityId = "lWgnfO6vrAZdeWa1aVThWzBLASr2"
        let entity = try await realTimeManagerAdapter?.getEntity(entityId: entityId)
        XCTAssertNotNil(entity)
    }
}
