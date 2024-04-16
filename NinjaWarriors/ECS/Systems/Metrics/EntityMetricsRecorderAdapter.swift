//
//  EntityMetricsRecorderAdapter.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 14/4/24.
//

import Foundation

class EntityMetricsRecorderAdapter: EntityMetricsRecorder {
    var matchID: String
    private let metricsRepository: MetricsRepository

    init(metricsRepository: MetricsRepository, matchID: String) {
        self.matchID = matchID
        self.metricsRepository = metricsRepository
    }

    func record<T>(_ metricType: T.Type, forEntityID entityID: EntityID, value: Double) where T: Metric {
        self.metricsRepository.updateMetrics(metricType, userID: entityID, inGame: matchID, withValue: value)
    }

    func resetAllMetrics(forEntityIDs entityIDs: [EntityID]) {
        self.metricsRepository.resetAllGameMetrics(forUsers: entityIDs)
    }

    func getRepository() -> MetricsRepository {
        metricsRepository
    }
}
