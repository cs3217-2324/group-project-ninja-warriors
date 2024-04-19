//
//  InGameAchievementsView.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 16/4/24.
//

import SwiftUI

struct InGameAchievementsView: View {
    @ObservedObject var achievementManager: AchievementManager
    let matchID: String
    let columns = [GridItem(.flexible())]

    var body: some View {
        Text("Achievements earned in this game")
            .font(.largeTitle)
            .padding()
        ScrollView {
            LazyVGrid(columns: columns) {
                let inGameAchievements = achievementManager.getUnlockedAchievements(fromGame: matchID)
                ForEach(inGameAchievements, id: \.title) { achievement in
                    AchievementRow(achievement: achievement, displayingInGame: true)
                }
            }
        }
    }
}
