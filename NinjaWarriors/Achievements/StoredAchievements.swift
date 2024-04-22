//
//  AchievementCounts.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

struct StoredAchievementDetail: Codable {
    var count: Int
    var lastGameWhenAchieved: GameID?

    init(from achievement: Achievement) {
        self.count = achievement.count
        self.lastGameWhenAchieved = achievement.lastGameWhenAchieved
    }
}

struct StoredAchievements: Codable {
    var userID: UserID
    var achievementCounts: [String: StoredAchievementDetail]

    init(userID: UserID, achievements: [Achievement]) {
        self.userID = userID
        self.achievementCounts = [:]

        for achievement in achievements {
            let achievementType = type(of: achievement)
            self.achievementCounts[String(describing: achievementType)] =  StoredAchievementDetail(from: achievement)
        }
    }

    func updateAchievement(achievement: inout Achievement) {
        let achievementTypeString = String(describing: type(of: achievement))
        if let newAchievementDetail = self.achievementCounts[achievementTypeString] {
            achievement.count = newAchievementDetail.count
            achievement.lastGameWhenAchieved = newAchievementDetail.lastGameWhenAchieved
        }
    }
}
