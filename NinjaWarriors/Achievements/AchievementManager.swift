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
    let achievementTypes: [Achievement.Type] = [
        HighDamageButNoKillAchievement.self,
        KilledTenPeopleAchievement.self,
        PlayedTenGamesAchievement.self,
        FirstDamageInGameAchievement.self,
        ThreeDashesInGameAchievement.self
    ]

    init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.achievements = achievementTypes.map { $0.init(userID: userID, metricsSubject: metricsSubject) }
    }

    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.count > 0 }
    }
}
