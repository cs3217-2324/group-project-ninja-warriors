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
    static let timeLag = 100

    // MARK: Player
    static let playerOnePosition = Point(xCoord: 100, yCoord: 100)
    static let playerTwoPosition = Point(xCoord: screenWidth - 100, yCoord: 100)
    static let playerThreePosition = Point(xCoord: 100, yCoord: screenHeight - 500)
    static let playerFourPosition = Point(xCoord: screenWidth - 100, yCoord: screenHeight - 500)
    static let playerPositions = [playerOnePosition, playerTwoPosition,
                                  playerThreePosition, playerFourPosition]

    struct HealthBar {
        static let height: CGFloat = 15
        static let offsetY: CGFloat = 15
    }

    struct GemCount {
        static let height: CGFloat = 25
        static let width: CGFloat = 25
        static let offsetX: CGFloat = 20
        static let offsetY: CGFloat = 15
    }

    static let playerCount = 2

    static let obstacleCount = 2
    static let gemCount = 4

    // MARK: Skills
    static let slashDamage = 30.0
    static let slashRadius = 75.0

    struct DodgeImage {
        static let image = "dodge"
        static let width: CGFloat = 100
        static let height: CGFloat = 100
    }

    static let hadoukenDamage = 20.0
    static let hadoukenDamagePerTick = 0.0
    static let hadoukenDamageDuration = 0.0
    static let hadoukenLifespan = 1.0

    // MARK: Closing Zone
    static var closingZonePosition: Point { Point(xCoord: screenWidth / 2.0, yCoord: screenHeight / 2.0 - 100) }
    static var closingZoneRadius: Double { screenHeight / 2.5 }
    static var closingZoneDPS: Double = 10.0
    static var closingZoneRadiusShrinkagePerSecond: Double = 10.0
    static var closingZoneMinimumSize: Double = 50.0

    // MARK: Gem Collection Mode
    static let gemRespawnTime: TimeInterval = 5.0
    static let gemCountToWin: Int = 2
    static let gemResetTime: TimeInterval = 10.0
    static let defaultGemID: String = "DefaultGem"

    // MARK: Characters
    static var characterNames: [String] = ["Shadowstrike", "Nightblade", "Swiftshadow", "SilentStorm",
                                    "Crimsonshadow", "Shadowblade", "Venomstrike", "Darkwind"]

    static var skills: [String: [String]] = ["Shadowstrike": ["Hadouken", "Slash", "Dash", "Refresh"],
                                      "Nightblade": ["Dash", "Hadouken", "Dodge", "Refresh"],
                                      "Swiftshadow": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "SilentStorm": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Crimsonshadow": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Shadowblade": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Venomstrike": ["Dash", "Slash", "Dodge", "Refresh"],
                                      "Darkwind": ["Dash", "Slash", "Dodge", "Refresh"]]

    static var shadowstrikeSkills: [Skill] = [HadoukenSkill(id: "hadouken", cooldownDuration: 8.0),
                                              SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                              DashSkill(id: "dash", cooldownDuration: 8.0),
                                              RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var shadowbladeSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                             RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var silentStormkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 3.0),
                                            DashSkill(id: "dash", cooldownDuration: 12.0),
                                            DodgeSkill(id: "dodge", cooldownDuration: 12.0),
                                            RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var swiftShadowSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 15.0),
                                             DashSkill(id: "dash", cooldownDuration: 3.0),
                                             DodgeSkill(id: "dodge", cooldownDuration: 3.0),
                                             RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var venomStrikeSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                             DashSkill(id: "dash", cooldownDuration: 3.0),
                                             DodgeSkill(id: "dodge", cooldownDuration: 12.0),
                                             RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var nightbladeSkills: [Skill] = [HadoukenSkill(id: "hadouken", cooldownDuration: 5.0),
                                            DashSkill(id: "dash", cooldownDuration: 10.0),
                                            DodgeSkill(id: "dodge", cooldownDuration: 10.0),
                                            RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var crimsonShadowSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 10.0),
                                               DashSkill(id: "dash", cooldownDuration: 10.0),
                                               DodgeSkill(id: "dodge", cooldownDuration: 10.0),
                                               RefreshCooldownsSkill(id: "refresh", cooldownDuration: 20.0)]

    static var darkwindSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 100.0),
                                          DashSkill(id: "dash", cooldownDuration: 100.0),
                                          DodgeSkill(id: "dodge", cooldownDuration: 100.0),
                                          RefreshCooldownsSkill(id: "refresh", cooldownDuration: 8.0)]

    static var defaultSkills: [Skill] = [SlashAOESkill(id: "slash", cooldownDuration: 5.0),
                                         DashSkill(id: "dash", cooldownDuration: 15.0),
                                         DodgeSkill(id: "dodge", cooldownDuration: 15.0),
                                         RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)]

    static var characterSkills: [String: [Skill]] = ["Shadowstrike": shadowstrikeSkills,
                                                     "Nightblade": nightbladeSkills,
                                                     "Swiftshadow": swiftShadowSkills,
                                                     "SilentStorm": silentStormkills,
                                                     "Crimsonshadow": crimsonShadowSkills,
                                                     "Shadowblade": shadowbladeSkills,
                                                     "Venomstrike": venomStrikeSkills,
                                                     "Darkwind": darkwindSkills]

    // Player IDs
    static let singlePlayerID = "singlePlayer"

    // Achievements
    static let availableAchievements: [Achievement.Type] = [
        LoginForTheFirstTimeAchievement.self,
        HighDamageButNoKillAchievement.self,
        KilledTenPeopleAchievement.self,
        PlayedTenGamesAchievement.self,
        FirstDamageInGameAchievement.self,
        FirstDamageForUserAchievement.self,
        ThreeDashesInGameAchievement.self,
        ThreeDodgesInGameAchievement.self,
        ThreeDodgesThreeDashesInGameAchievement.self
    ]
    static let localAchievementsFileName: String = "achievements.json"
    static let achievementsFirebaseCollectionID: String = "achievements"

    // Metrics
    static let localMetricsFileName: String = "metrics.json"
    static let metricsFirebaseCollectionID: String = "metrics"
}
