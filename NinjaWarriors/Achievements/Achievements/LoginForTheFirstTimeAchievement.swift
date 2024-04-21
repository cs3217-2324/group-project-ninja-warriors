//
//  LoginForTheFirstTimeAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

class LoginForTheFirstTimeAchievement: Achievement {
    var title: String = "Welcome!"
    var description: String = "Logged in for the first time"
    var imageAsset: String = "achievement-first-login"
    var isRepeatable = false
    var count: Int = 0
    var lastGameWhenAchieved: GameID?
    var dependentMetrics: [Metric.Type] = [LoginCountMetric.self]
    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }
}

extension LoginForTheFirstTimeAchievement: MetricObserver {
    func metricDidChange(_ metric: Metric) {
        guard count < 1 else { return }
        guard let loginCountMetric = metric as? LoginCountMetric else { return }
        guard loginCountMetric.value > 0 else { return }
        count += 1
    }
}
