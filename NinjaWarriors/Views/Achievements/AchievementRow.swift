//
//  AchievementRow.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 16/4/24.
//

import SwiftUI

struct AchievementRow: View {
    var achievement: Achievement

    var body: some View {
        HStack(alignment: .center) {
            Image(achievement.imageAsset)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .overlay(
                    achievement.isUnlocked
                    ? nil
                    : lockedOverlay())
            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
                Text(achievement.description)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            // text inside circle describing count
            Spacer()
            if achievement.isRepeatable && achievement.isUnlocked {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("\(achievement.count)")
                            .font(.title2)
                            .foregroundStyle(.white)
                    )
            }
//            Spacer()
        }.padding()
    }

    private func lockedOverlay() -> some View {
        return ZStack {
            Color.gray.opacity(0.5)
            Image(systemName: "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundColor(.white.opacity(0.8))

        }
    }
}
