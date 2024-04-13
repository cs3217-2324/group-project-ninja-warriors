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

    var imageAsset: String = "pacifist-maniac-achievement"

    var isRepeatable: Bool = true

    var count: Int

    var didKillSomeone: Bool = false
    var damageExceeded100: Bool = false
    var lastGameWhenAchieved: GameID?

    init(userID: UserID, metricsRepository: MetricsRepository) {
        count = 0
        metricsRepository.registerObserverForUser(self, for: KillCountMetric.self, userID: userID)
        metricsRepository.registerObserverForUser(self, for: DamageDealtMetric.self, userID: userID)
    }

    func updateAchievement(inGame gameID: GameID?) {
        if !didKillSomeone && damageExceeded100 {
            count += 1
            lastGameWhenAchieved = gameID
        }
    }
}

extension HighDamageButNoKillAchievement: MetricObserver {
    func notify(_ metric: Metric) {
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
