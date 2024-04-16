//
//  ThreeDashesInGameAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 15/4/24.
//

import Foundation

class ThreeDashesInGameAchievement: Achievement {
    var title: String = "Dashing Around"
    var description: String = "Make three dashes in a single game"
    var imageAsset: String = "achievement-three-dashes-in-game"
    var isRepeatable: Bool = true
    var count: Int = 0
    var lastGameWhenAchieved: GameID?
    var dependentMetrics: [Metric.Type] = [DashesCountMetric.self]
    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }
}

extension ThreeDashesInGameAchievement: MetricObserver {
    func notify(_ metric: Metric) {
        guard lastGameWhenAchieved != metric.lastGame else { return }
        guard let dashesCountMetric = metric as? DashesCountMetric else { return }
        guard dashesCountMetric.inGameValue >= 3 else { return }
        count += 1
        lastGameWhenAchieved = metric.lastGame
    }
}
