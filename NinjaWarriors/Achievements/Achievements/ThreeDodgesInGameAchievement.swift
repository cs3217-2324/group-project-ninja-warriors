//
//  ThreeDodgesInGameAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

class ThreeDodgesInGameAchievement: Achievement {
    var title: String = "Float like a Butterfly"
    var description: String = "Made three dodges in a single game"
    var imageAsset: String = "achievement-three-dodges"
    var isRepeatable = true
    var count: Int = 0
    var lastGameWhenAchieved: GameID?
    var dependentMetrics: [Metric.Type] = [AttacksDodgedMetric.self]
    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }
}

extension ThreeDodgesInGameAchievement: MetricObserver {
    func metricDidChange(_ metric: Metric) {
        guard lastGameWhenAchieved != metric.lastGame else { return }
        guard let dodgeCountMetric = metric as? AttacksDodgedMetric else { return }
        guard dodgeCountMetric.inGameValue >= 3 else { return }
        count += 1
        lastGameWhenAchieved = metric.lastGame
    }
}
