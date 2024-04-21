//
//  AchievementManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

class AchievementManager: ObservableObject {
    var userID: UserID
    @Published var achievements: [Achievement]
    var storageManager: StorageManager

    init(userID: UserID, metricsSubject: MetricsSubject) {
        self.userID = userID
        self.achievements = Constants.availableAchievements.map { $0.init(userID: userID, metricsSubject: metricsSubject) }
        self.storageManager = LocalStorageManager(filename: Constants.localAchievementsFileName)
        loadAchievementCounts()
    }

    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.count > 0 }
    }

    func getUnlockedAchievements(fromGame matchID: String) -> [Achievement] {
        return unlockedAchievements.filter { achievement in
            achievement.lastGameWhenAchieved == matchID
        }
    }

    func saveAchievementCounts() {
        let counts = getCurrentAchievementCounts()
        storageManager.save(counts)
    }

    private func getCurrentAchievementCounts() -> AchievementCounts {
        return AchievementCounts(userID: userID, achievements: achievements)
    }

    private func loadAchievementCounts() {
        guard let counts: AchievementCounts = storageManager.load() else {
            return
        }
        updateAchievementCounts(from: counts)
    }

    private func updateAchievementCounts(from counts: AchievementCounts) {
        for index in achievements.indices {
            counts.updateAchievement(achievement: &achievements[index])
        }
    }
}
