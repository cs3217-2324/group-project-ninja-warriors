//
//  HighDamageButNoKillAchievement.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

class HighDamageButNoKillAchievement: Achievement {

    var title: String = "Pacifist Maniac"

    var description: String = "Inflict 100HP of damage without killing."

    var imageAsset: String = "achievement-pacifist-maniac"

    var isRepeatable: Bool = true

    var count: Int = 0

    var lastGameWhenAchieved: GameID?

    var dependentMetrics: [Metric.Type] = [KillCountMetric.self, DamageDealtMetric.self]

    var userID: UserID

    private var didKillSomeone: Bool = false
    private var damageExceeded100: Bool = false

    required init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        subscribeToMetrics(withObserver: self, metricsSubject: metricsSubject)
    }

    func updateAchievement(inGame gameID: GameID?) {
        if !didKillSomeone && damageExceeded100 {
            count += 1
            lastGameWhenAchieved = gameID
        }
    }
}

extension HighDamageButNoKillAchievement: MetricObserver {
    func metricDidChange(_ metric: Metric) {
        guard metric.lastGame != self.lastGameWhenAchieved else {
            return
        }
        if let killCountMetric = metric as? KillCountMetric {
            updateKillCount(killCountMetric)
        }
        if let damageDealtMetric = metric as? DamageDealtMetric {
            updateDamageDealt(damageDealtMetric)
        }
        updateAchievement(inGame: metric.lastGame)
    }

    func updateKillCount(_ metric: KillCountMetric) {
        if metric.inGameValue >= 1 {
            didKillSomeone = true
        }
    }

    func updateDamageDealt(_ metric: DamageDealtMetric) {
        if metric.inGameValue >= 100 {
            damageExceeded100 = true
        }
    }
}
