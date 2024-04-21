//
//  GameOverView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/4/24.
//

import Foundation
import SwiftUI

struct GameAchievement {
    var title: String
    var description: String
}

struct GameOverView: View {
    @State private var showingAchievements = false
    @Binding var path: NavigationPath
    @ObservedObject var achievementManager: AchievementManager
    var matchID: String

    var body: some View {
        VStack {
            Text("Game Over")
                .font(.custom("KARASHA", size: 50))
                .foregroundColor(.red)
                .shadow(radius: 10)
                .padding()

            Button(action: {
                showingAchievements.toggle()
            }) {
                Text("View Achievements")
                    .font(.custom("KARASHA", size: 25))
                    .foregroundColor(.black)
            }
            .padding()

            Button(action: {
                path = NavigationPath()
            }, label: {
                Text("Back to Home")
                    .font(.custom("KARASHA", size: 25))
                    .foregroundColor(.black)
            })
        }
        .background(
            Image("scroll")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
        )
        .sheet(isPresented: $showingAchievements) {
            InGameAchievementsView(achievementManager: achievementManager, matchID: matchID)
        }
        .onAppear {
            achievementManager.saveAchievementCounts()
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(path: .constant(NavigationPath()), achievementManager: AchievementManager(userID: "test", metricsSubject: MetricsRepository(), shouldStoreOnCloud: false), matchID: "match")
    }
}
