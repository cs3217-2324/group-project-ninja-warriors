//
//  KilledTenPeopleAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

class KilledTenPeopleAchievement: Achievement {
    var title: String = "Serial Killer"

    var description: String = "Killed ten enemies over one or more games."

    var imageAsset: String = "killed-ten-achievement"

    var isRepeatable: Bool = false

    var count: Int

    init(userID: UserID, metricsRepository: MetricsRepository) {
        count = 0
        metricsRepository.registerObserverForUser(self, for: KillCountMetric.self, userID: userID)
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
            //TODO: maybe deregister observer, but a bit annoying
        }
    }
}
