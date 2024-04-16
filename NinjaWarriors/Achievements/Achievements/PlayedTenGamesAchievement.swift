//
//  PlayedTenGamesAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

class PlayedTenGamesAchievement: Achievement {
    var title: String = "Getting Started"

    var description: String = "Play ten games"

    var imageAsset: String = "ten-games"

    var isRepeatable: Bool = false

    var count: Int = 0

    var lastGameWhenAchieved: GameID?

    var dependentMetrics: [Metric.Type] = [GamesPlayedMetric.self]

    var userID: UserID

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }
}

extension PlayedTenGamesAchievement: MetricObserver {
    func notify(_ metric: Metric) {
        guard count == 0 else {
            return
        }

        guard let gameCountMetric = metric as? GamesPlayedMetric else {
            return
        }

        if gameCountMetric.value >= 10 {
            count += 1
        }
    }
}
