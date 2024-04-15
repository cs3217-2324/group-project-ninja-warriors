//
//  Constants.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import Foundation
import SwiftUI

struct Constants {
    static let screenHeight = UIScreen.main.bounds.size.height - 250
    static let screenWidth = UIScreen.main.bounds.size.width
    static let defaultSize: CGFloat = 25.0
    static let directory = "NinjaWarriors."
    static let wrapperName = "Wrapper"
    static let timeLag = 20

    // MARK: Player
    static let playerOnePosition = Point(xCoord: 100, yCoord: 100)
    static let playerTwoPosition = Point(xCoord: screenWidth - 100, yCoord: 100)
    static let playerThreePosition = Point(xCoord: 100, yCoord: screenHeight - 500)
    static let playerFourPosition = Point(xCoord: screenWidth - 100, yCoord: screenHeight - 500)
    static let playerPositions = [playerOnePosition, playerTwoPosition,
                                  playerThreePosition, playerFourPosition]

    struct HealthBar {
        static let height: CGFloat = 10
        static let offsetY: CGFloat = 15
    }

    // TODO: Reset to 4 after testing
    static let playerCount = 1

    static let obstacleCount = 2
    static let gemCount = 4

    // MARK: Skills
    static let slashDamage = 10.0
    static let slashRadius = 75.0

    struct DodgeImage {
        static let image = "dodge"
        static let width: CGFloat = 100
        static let height: CGFloat = 100
    }

    // MARK: Closing Zone
    static var closingZonePosition: Point { Point(xCoord: screenWidth / 2.0, yCoord: screenHeight / 2.0 - 100) }
    static var closingZoneRadius: Double { screenHeight / 2.5 }
    static var closingZoneDPS: Double = 1.0
    static var closingZoneRadiusShrinkagePerSecond: Double = 10.0
    static var closingZoneMinimumSize: Double = 50.0

    // MARK: Characters
    static var characterNames: [String] = ["Shadowstrike", "Nightblade", "Swiftshadow", "SilentStorm",
                                    "Crimsonshadow", "Shadowblade", "Venomstrike", "Darkwind"]

    static var skills: [String: [String]] = ["Shadowstrike": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Nightblade": ["Dash", "Hadouken", "Dodge", "Refresh"],
                                      "Swiftshadow": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "SilentStorm": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Crimsonshadow": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Shadowblade": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Venomstrike": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Darkwind": ["Dash", "Slash", "Dodge", "Refresh"]]

    static var shadowstrikeSkills: [Skill] = [HadoukenSkill(id: "hadouken", cooldownDuration: 0.0),
                                              DashSkill(id: "dash", cooldownDuration: 0.0),
                                              DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                              RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var shadowbladeSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                             RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var silentStormkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                            DashSkill(id: "dash", cooldownDuration: 8.0),
                                            DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                            RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var swiftShadowSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                             RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var venomStrikeSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                             RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var nightbladeSkills: [Skill] = [HadoukenSkill(id: "hadouken", cooldownDuration: 8.0),
                                            DashSkill(id: "dash", cooldownDuration: 8.0),
                                            DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                            RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var crimsonShadowSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                               DashSkill(id: "dash", cooldownDuration: 8.0),
                                               DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                               RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var darkwindSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                          DashSkill(id: "dash", cooldownDuration: 8.0),
                                          DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                          RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var defaultSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                         DashSkill(id: "dash", cooldownDuration: 8.0),
                                         DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                         RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var characterSkills: [String: [Skill]] = ["Shadowstrike": shadowstrikeSkills,
                                                     "Nightblade": nightbladeSkills,
                                                     "Swiftshadow": swiftShadowSkills,
                                                     "SilentStorm": silentStormkills,
                                                     "Crimsonshadow": crimsonShadowSkills,
                                                     "Shadowblade": shadowbladeSkills,
                                                     "Venomstrike": venomStrikeSkills,
                                                     "Darkwind": darkwindSkills]
}
