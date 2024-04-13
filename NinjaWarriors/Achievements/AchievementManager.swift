//
//  AchievementManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

class AchievementManager {
    let userID: UserID
    let achievements: [Achievement]

    init(userID: UserID, metricsRepository: MetricsRepository) {
        self.userID = userID
        self.achievements = [
            HighDamageButNoKillAchievement(userID: userID, metricsRepository: metricsRepository),
            KilledTenPeopleAchievement(userID: userID, metricsRepository: metricsRepository),
            PlayedTenGamesAchievement(userID: userID, metricsRepository: metricsRepository)
        ]
    }

    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.count > 0 }
    }
}
