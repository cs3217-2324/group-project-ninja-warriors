//
//  FirstDamageForUserAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

class FirstDamageForUserAchievement: Achievement {
    var title: String = "Baby's First Attack"
    var description: String = "Dealt damage for the first time as a user"
    var imageAsset: String = "achievement-first-damage-for-user"
    var isRepeatable: Bool = true
    var count: Int = 0
    var lastGameWhenAchieved: GameID?
    var dependentMetrics: [Metric.Type] = [DamageDealtMetric.self]
    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }
}

extension FirstDamageForUserAchievement: MetricObserver {
    func metricDidChange(_ metric: Metric) {
        guard count < 1 else { return }
        guard let damageMetric = metric as? DamageDealtMetric else { return }
        guard damageMetric.value > 0 else { return }
        count += 1
    }
}
