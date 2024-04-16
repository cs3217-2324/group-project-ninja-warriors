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

    // Mock achievements data
    let achievements: [GameAchievement] = [
        GameAchievement(title: "First Victory", description: "You won your first game!"),
        GameAchievement(title: "Master Collector", description: "You collected all the gems."),
        GameAchievement(title: "Speed Runner", description: "You completed the game in record time!")
    ]

    var body: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Button(action: {
                showingAchievements.toggle()
            }) {
                Text("View Achievements")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .sheet(isPresented: $showingAchievements) {
            AchievementSheet(achievements: achievements)
        }
    }
}

struct AchievementSheet: View {
    let achievements: [GameAchievement]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(achievements, id: \.title) { achievement in
                VStack(alignment: .leading, spacing: 8) {
                    Text(achievement.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(achievement.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .navigationBarTitle("Achievements")
            .navigationBarItems(trailing:
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
