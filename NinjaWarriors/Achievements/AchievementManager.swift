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

    init(userID: UserID, metricsSubject: MetricsSubject, shouldStoreOnCloud: Bool) {
        self.userID = userID
        self.achievements = Constants.availableAchievements.map { $0.init(userID: userID, metricsSubject: metricsSubject) }

        if shouldStoreOnCloud {
            self.storageManager = FirestoreStorageManager(
                collectionID: Constants.achievementsFirebaseCollectionID,
                userID: userID
            )
        } else {
            let filename = userID + "-" + Constants.localAchievementsFileName
            self.storageManager = LocalStorageManager(filename: filename)
        }

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

    func loadAchievementCounts() {
        storageManager.load { [weak self] (counts: AchievementCounts?, _) in
            guard let counts = counts else { return }
            guard let self = self else { return }
            self.updateAchievementCounts(from: counts)
        }
    }

    private func updateAchievementCounts(from counts: AchievementCounts) {
        for index in achievements.indices {
            counts.updateAchievement(achievement: &achievements[index])
        }
    }
}
