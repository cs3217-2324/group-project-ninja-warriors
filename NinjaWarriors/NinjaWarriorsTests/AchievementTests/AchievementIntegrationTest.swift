//
//  AchievementIntegrationTest.swift
//  NinjaWarriorsTests
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation
import XCTest
@testable import NinjaWarriors

final class AchievementIntegrationTests: XCTestCase {
    func test_killedTenPeopleAchievement_unlocked() {
        let userID = "test"
        let metricsRepository = MetricsRepository(activeUser: "test", shouldStoreOnCloud: false)
        let achievementManager = AchievementManager(userID: userID,
                                                    metricsSubject: metricsRepository,
                                                    shouldStoreOnCloud: false)

        for _ in 0..<10 {
            metricsRepository.updateMetrics(KillCountMetric.self, for: userID, withValue: 1)
        }
        assert(!achievementManager.unlockedAchievements.isEmpty)
    }
}
