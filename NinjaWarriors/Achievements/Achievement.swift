//
//  Achievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

protocol Achievement: MetricObserver {
    var title: String { get }
    var description: String { get }
    var imageAsset: String { get }

    var isRepeatable: Bool { get }
    var count: Int { get set }
    var lastGameWhenAchieved: GameID? { get set }

    var dependentMetrics: [Metric.Type] { get }

    var userID: UserID { get }

    init(userID: UserID, metricsSubject: MetricsSubject)
}

extension Achievement {
    func subscribeToMetrics(withObserver observer: MetricObserver, metricsSubject: MetricsSubject) {
        for metric in dependentMetrics {
            metricsSubject.initializeMetricForUser(metricType: metric, userID: userID)
            metricsSubject.addObserver(observer, for: metric, userID: userID)
        }
    }

    var isUnlocked: Bool {
        return count > 0
    }
}
