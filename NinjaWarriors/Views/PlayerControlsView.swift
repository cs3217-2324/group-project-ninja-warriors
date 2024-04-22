//
//  PlayerControlsView.swift
//  NinjaWarriors
//
//  Created by Joshen on 4/4/24.
//

import Foundation
import SwiftUI

struct PlayerControlsView: View {
    let playerHealth: Health?
    let skills: [Dictionary<SkillID, any Skill>.Element]
    let skillCooldowns: [SkillID: TimeInterval]
    var toggleEntityOverlay: () -> Void
    var activateSkill: (String) -> Void

    let skillContainerRadius = 140.0
    let skillRadius = 90.0

    let width: CGFloat = 200  // width of the health bar
    let height: CGFloat = 20  // height of the health bar

    var body: some View {
        HStack {
            VStack {
                healthBar

                ZStack {
                    Button(action: toggleEntityOverlay, label: {
                        Image(systemName: "eye")
                            .accessibilityLabel("Toggle Entity Overlay")
                        Text("ECS")
                    })
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white.opacity(0.5))
                    .cornerRadius(10.0)
                }
            }
            HStack {
                ForEach(skills, id: \.key) { key, _ in
                    VStack {
                        ZStack {
                            Image("skill-container-button")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: skillContainerRadius, height: skillContainerRadius)

                            Button(action: {
                                activateSkill(key)
                            }) {
                                ZStack {
                                    Image("skill-\(key)")
                                        .resizable()
                                        .frame(width: skillRadius, height: skillRadius)
                                    if skillCooldowns[key] ?? 0.0 > 0 {
                                        Rectangle()
                                            .fill(Color.black.opacity(0.8))
                                            .frame(width: skillRadius, height: skillRadius)
                                    }

                                    if skillCooldowns[key] ?? 0.0 > 0 {
                                        Text("\(String(format: "%.1f", skillCooldowns[key] ?? 0.0))")
                                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                                            .foregroundColor(.white)
                                            .textCase(.uppercase)
                                    }
                                }
                            }
                            .padding()
                            //                            .simultaneousGesture(TapGesture().onEnded {
                            //                                AudioManager.shared.playSkillAudio(for: value.audio)
                            //                            })
                        }
                        Text("\(key)").fontWeight(.bold).foregroundColor(.white).textCase(.uppercase)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Image("player-controls")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
        )
    }

    private var healthBar: some View {
        VStack {
            if let health = playerHealth {
                Text("\(String(format: "%.0f", health.health))/\(String(format: "%.0f", health.maxHealth))")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .font(.system(size: 24, design: .monospaced))
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.red.opacity(1.0))
                                .border(.gray)
                                .frame(width: geometry.size.width, height: height)

                            Rectangle()
                                .fill(.green)
                                .border(.gray)
                                .frame(width: CGFloat(health.health) / CGFloat( health.maxHealth)
                                       * geometry.size.width, height: height)
                                .animation(.linear, value: health.health)
                        }
                    }
                    .frame(width: width, height: height)
                    .cornerRadius(5.0)
                }
            }
        }.padding()
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static func mockHealth() -> Health {
        let health = Health(id: RandomNonce().randomNonceString(), entity: Player(id: "temp-player"),
                            entityInflictDamageMap: [:], health: 94, maxHealth: 100)

        return health
    }

    static func mockSkills() -> [Dictionary<SkillID, any Skill>.Element] {
        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: Player(id: "1"),
                                      skills: [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                               DashSkill(id: "dash", cooldownDuration: 8.0),
                                               DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                               RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)])
        return Array(skillCaster.skills)
    }

    static func mockSkillCooldowns() -> [SkillID: TimeInterval] {
        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: Player(id: "1"),
                                      skills: [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                               DashSkill(id: "dash", cooldownDuration: 8.0),
                                               DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                               RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)])
        return skillCaster.skillCooldowns
    }

    static var previews: some View {
        PlayerControlsView(
            playerHealth: PlayerControlsView_Previews.mockHealth(),
            skills: PlayerControlsView_Previews.mockSkills(),
            skillCooldowns: PlayerControlsView_Previews.mockSkillCooldowns(),
            toggleEntityOverlay: {
                print("Toggle Entity Overlay")
            },
            activateSkill: { skillId in
                print("Activating skill: \(skillId)")
            }
        )
    }
}
