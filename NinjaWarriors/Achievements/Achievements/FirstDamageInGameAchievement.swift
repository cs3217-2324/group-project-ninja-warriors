//
//  FirstDamageInGameAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 15/4/24.
//

import Foundation

class FirstDamageInGameAchievement: Achievement {
    var title: String = "Getting Your Hands Dirty"
    var description: String = "Dealt damage for the first time in a game"
    var imageAsset: String = "first-damage"
    var isRepeatable: Bool = true
    var count: Int = 0
    var lastGameWhenAchieved: GameID?
    var dependentMetrics: [Metric.Type] = [DamageDealtMetric.self]
    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }

    func update() {
        count += 1
    }
}

extension FirstDamageInGameAchievement: MetricObserver {
    func notify(_ metric: Metric) {
        guard lastGameWhenAchieved != metric.lastGame else { return }
        guard let damageMetric = metric as? DamageDealtMetric else { return }
        guard damageMetric.value > 0 else { return }
        count += 1
        lastGameWhenAchieved = metric.lastGame
    }
}
