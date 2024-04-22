//
//  ThreeDodgesThreeDashesInGameAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

class ThreeDodgesThreeDashesInGameAchievement: Achievement {
    var title: String = "Dasher and Dancer"
    var description: String = "Made three dodges and three dashes in a single game"
    var imageAsset: String = "achievement-three-dodges-three-dashes"
    var isRepeatable = true
    var count: Int = 0
    var lastGameWhenAchieved: GameID?
    var dependentMetrics: [Metric.Type] = [AttacksDodgedMetric.self, DashesCountMetric.self]
    var userID: UserID

    private var didDashThreeTimes: Bool = false
    private var didDodgeThreeTimes: Bool = false

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }

    func updateAchievement(inGame gameID: GameID?) {
        if didDashThreeTimes && didDodgeThreeTimes {
            count += 1
            lastGameWhenAchieved = gameID
        }
    }
}

extension ThreeDodgesThreeDashesInGameAchievement: MetricObserver {
    func metricDidChange(_ metric: Metric) {
        guard lastGameWhenAchieved != metric.lastGame else { return }
        if let dashCountMetric = metric as? DashesCountMetric {
            didDashThreeTimes = dashCountMetric.inGameValue >= 3
        }
        if let dodgeCountMetric = metric as? AttacksDodgedMetric {
            didDodgeThreeTimes = dodgeCountMetric.inGameValue >= 3
        }
        updateAchievement(inGame: metric.lastGame)
    }
}
