//
//  AchievementCounts.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

struct StoredAchievements: Codable {
    var userID: UserID
    var achievementCounts: [String: Int]

    init(userID: UserID, achievements: [Achievement]) {
        self.userID = userID
        self.achievementCounts = [:]

        for achievement in achievements {
            let achievementType = type(of: achievement)
            self.achievementCounts[String(describing: achievementType)] = achievement.count
        }
    }

    func updateAchievement(achievement: inout Achievement) {
        let achievementTypeString = String(describing: type(of: achievement))
        if let newCount = self.achievementCounts[achievementTypeString] {
            achievement.count = newCount
        }
    }
}
