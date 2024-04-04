//
//  PlayerControlsView.swift
//  NinjaWarriors
//
//  Created by Joshen on 4/4/24.
//

import Foundation
import SwiftUI

struct PlayerControlsView: View {
    let skills: [Dictionary<SkillID, any Skill>.Element]
    var toggleEntityOverlay: () -> Void
    var activateSkill: (String) -> Void

    var body: some View {
        HStack {
            ZStack {
                Button(action: toggleEntityOverlay, label: {
                    Image(systemName: "eye")
                        .accessibilityLabel("Toggle Entity Overlay")
                })
                .padding()
                .background(Color.purple.opacity(0.7))
                .foregroundColor(.white)
                .clipShape(Circle())
            }
            HStack {
                ForEach(skills, id: \.key) { key, value in
                    VStack {
                        ZStack {
                            Image("skill-container-button")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                            
                            Button(action: {
                                activateSkill(key)
                            }) {
                                ZStack {
                                    Image("skill-\(key)")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    if value.cooldownRemaining > 0 {
                                        Rectangle()
                                            .fill(Color.black.opacity(0.8))
                                            .frame(width: 100, height: 100)
                                    }
                                    
                                    if value.cooldownRemaining > 0 {
                                        Text("\(String(format: "%.1f", value.cooldownRemaining))")
                                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                                            .foregroundColor(.white)
                                            .textCase(.uppercase)
                                    }
                                }
                            }
                            .padding()
                        }
                        Text("\(key)").fontWeight(.bold).foregroundColor(.white).textCase(.uppercase)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Image("player-controls")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
        )
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static func mockSkills() -> [Dictionary<SkillID, any Skill>.Element] {
        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: Player(id: "1"), skills: [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                                            RefreshCooldownsSkill(id: "refresh")])
        return Array(skillCaster.skills)
    }
    
    static var previews: some View {
        PlayerControlsView(
            skills: PlayerControlsView_Previews.mockSkills(),
            toggleEntityOverlay: {
                print("Toggle Entity Overlay")
            },
            activateSkill: { skillId in
                print("Activating skill: \(skillId)")
            }
        )
    }
}
