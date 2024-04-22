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
    var storageManager: SingleDocumentStorageManager

    init(userID: UserID, metricsSubject: MetricsSubject, shouldStoreOnCloud: Bool) {
        self.userID = userID
        self.achievements = Constants.availableAchievements.map { $0.init(userID: userID,
                                                                          metricsSubject: metricsSubject) }

        if shouldStoreOnCloud {
            self.storageManager = SingleDocumentStorageFirestoreAdapter(
                collectionID: Constants.achievementsFirebaseCollectionID,
                userID: userID
            )
        } else {
            let filename = userID + "-" + Constants.localAchievementsFileName
            self.storageManager = SingleDocumentStorageLocalAdapter(filename: filename)
        }

        loadAchievementCounts()
    }

    deinit {
        saveAchievementCounts()
    }

    var unlockedAchievements: [Achievement] {
        return achievements.filter { $0.count > 0 }
    }

    func getUnlockedAchievements(fromGame matchID: String) -> [Achievement] {
        return unlockedAchievements.filter { achievement in
            achievement.lastGameWhenAchieved == matchID
        }
    }

    private func saveAchievementCounts() {
        let counts = getCurrentAchievementCounts()
        storageManager.save(counts)
    }

    private func getCurrentAchievementCounts() -> StoredAchievements {
        return StoredAchievements(userID: userID, achievements: achievements)
    }

    private func loadAchievementCounts() {
        storageManager.load { [weak self] (counts: StoredAchievements?, _) in
            guard let counts = counts else { return }
            guard let self = self else { return }
            self.updateAchievementCounts(from: counts)
        }
    }

    private func updateAchievementCounts(from counts: StoredAchievements) {
        for index in achievements.indices {
            counts.updateAchievement(achievement: &achievements[index])
        }
    }
}
