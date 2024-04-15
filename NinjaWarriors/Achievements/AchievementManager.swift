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

    init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.achievements = [
            HighDamageButNoKillAchievement(userID: userID, metricsSubject: metricsSubject),
            KilledTenPeopleAchievement(userID: userID, metricsSubject: metricsSubject),
            PlayedTenGamesAchievement(userID: userID, metricsSubject: metricsSubject)
        ]
    }

    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.count > 0 }
    }
}
