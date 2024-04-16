//
//  KilledTenPeopleAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

class KilledTenPeopleAchievement: Achievement {
    var title: String = "Serial Killer"

    var description: String = "Killed ten people over one or more games"

    var imageAsset: String = "killed-ten"

    var isRepeatable: Bool = false

    var count: Int = 0

    var lastGameWhenAchieved: GameID?

    var dependentMetrics: [Metric.Type] = [KillCountMetric.self]

    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.count = 0
        self.userID = userID
        self.subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }
}

extension KilledTenPeopleAchievement: MetricObserver {
    func notify(_ metric: Metric) {
        guard count < 1 else {
            return
        }

        guard let killCountMetric = metric as? KillCountMetric else {
            return
        }

        if killCountMetric.value >= 10 {
            count += 1
            // TODO: maybe deregister observer, but a bit annoying
        }
    }
}
