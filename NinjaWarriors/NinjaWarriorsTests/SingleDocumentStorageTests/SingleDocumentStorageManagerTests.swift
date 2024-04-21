//
//  SingleDocumentStorageManagerTests.swift
//  NinjaWarriorsTests
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation
import XCTest
@testable import NinjaWarriors

final class SingleDocumentStorageManagerTests: XCTestCase {
    func test_localSave_canRetrieveMetrics() {
        let storageManager = SingleDocumentStorageLocalAdapter(filename: "testMetricsFile.json")
        let storedMetrics = StoredMetrics(userID: "test", userMetrics: [:])

        // Create an expectation for metrics loading
        let metricsExpectation = expectation(description: "Metrics loaded")

        // Save the metrics
        storageManager.save(storedMetrics)

        // Load the metrics
        storageManager.load { (loadedMetrics: StoredMetrics?, error: Error?) in
            defer {
                // Fulfill the expectation after metrics are loaded or an error occurs
                metricsExpectation.fulfill()
            }

            guard let loadedMetrics = loadedMetrics else {
                XCTFail("Failed to load metrics: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Assert that loaded metrics match the stored metrics
            XCTAssertEqual(loadedMetrics.userID, storedMetrics.userID)
            XCTAssertEqual(loadedMetrics.metricsCounts, storedMetrics.metricsCounts)
        }

        // Wait for the metrics expectation to be fulfilled
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test_localSave_canRetrieveAchievements() {
        let storageManager = SingleDocumentStorageLocalAdapter(filename: "testAchievementsFile.json")
        let storedMetrics = StoredMetrics(userID: "test", userMetrics: [:])
        let storedAchievements = StoredAchievements(userID: "test", achievements: [])
        // Create an expectation for achievements loading
        let achievementsExpectation = expectation(description: "Achievements loaded")

        // Save the achievements
        storageManager.save(storedAchievements)

        // Load the achievements
        storageManager.load { (loadedAchievements: StoredAchievements?, error: Error?) in
            defer {
                // Fulfill the expectation after achievements are loaded or an error occurs
                achievementsExpectation.fulfill()
            }

            guard let loadedAchievements = loadedAchievements else {
                XCTFail("Failed to load achievements: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Assert that loaded achievements match the stored achievements
            XCTAssertEqual(loadedAchievements.userID, storedAchievements.userID)
            XCTAssertEqual(loadedAchievements.achievementCounts, storedAchievements.achievementCounts)
        }

        // Wait for the achievements expectation to be fulfilled
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test_localSave_canRetrieveArbitraryItems() {
        let storageManager = SingleDocumentStorageLocalAdapter(filename: "testAchievementsFile.json")
        let storedItem = StoredTestItem(testItem: "grocery", vegetableColors: [
            "carrot": "orange",
            "lettuce": "green",
            "beetroot": "red",
            "onions": "white",
            "potato": "bad"
        ])

        // Create an expectation for the stored item loading
        let storedItemExpectation = expectation(description: "Stored item loaded")

        // Save the item
        storageManager.save(storedItem)

        // Load the item
        storageManager.load { (loadedItem: StoredTestItem?, error: Error?) in
            defer {
                // Fulfill the expectation after the item is loaded or an error occurs
                storedItemExpectation.fulfill()
            }

            guard let loadedItem = loadedItem else {
                XCTFail("Failed to load stored item: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Assert that loaded item matches the stored item
            XCTAssertEqual(loadedItem.testItem, storedItem.testItem)
            XCTAssertEqual(loadedItem.vegetableColors, storedItem.vegetableColors)
        }

        // Wait for the stored item expectation to be fulfilled
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}

struct StoredTestItem: Codable {
    var testItem: String
    var vegetableColors: [String: String]
}
