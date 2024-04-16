//
//  ClientViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

@MainActor
final class ClientViewModel: ObservableObject {
    var gameWorld: GameWorld
    var metricsRepository: MetricsRepository
    internal var entities: [Entity] = []
    internal var matchId: String
    internal var currPlayerId: String
    var time: Int = 0
    let timeLag: Int = 3
    var isGameOver: Bool = false

    init(matchId: String, currPlayerId: String, ownEntities: [Entity],
         metricsRepository: MetricsRepository, achievementManager: AchievementManager, gameMode: GameMode) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        self.metricsRepository = metricsRepository
        let metricsRecorder = EntityMetricsRecorderAdapter(metricsRepository: metricsRepository, matchID: matchId)
        self.gameWorld = GameWorld(for: matchId,
                                   metricsRecorder: metricsRecorder,
                                   achievementManager: achievementManager,
                                   gameMode: gameMode)

        gameWorld.entityComponentManager.addOwnEntities(ownEntities)

        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            Task {
                await self.updateViewModel()
            }
        }
    }

    func updateViewModel() async {
        do {
            try await gameWorld.entityComponentManager.publish()
            if time == timeLag {
                await gameWorld.entityComponentManager.populate()
                updateEntities()
                time = 0
            }
            time += 1
        } catch {
            print("Error publishing updated state: \(error)")
        }
        updateViews()
        getAchivements()
    }

    func updateEntities() {
        entities = gameWorld.entityComponentManager.getAllEntities()
    }

    func updateGameState() {
        self.isGameOver = gameWorld.isGameOver
    }

    // Only update values that changed
    func updateViews() {
        objectWillChange.send()
    }

    func getCurrPlayer() -> Entity? {
        for entity in entities where entity.id == currPlayerId {
            return entity
        }
        return nil
    }

    func getComponents(for entity: Entity) -> [Component] {
        let entityComponents = gameWorld.entityComponentManager.getAllComponents(for: entity)

        return entityComponents
    }

    func move(_ vector: CGVector) {
        guard let entityIdComponents = gameWorld.entityComponentManager.entityComponentMap[currPlayerId] else {
            return
        }
        for entityIdComponent in entityIdComponents {
            if let entityIdComponent = entityIdComponent as? Rigidbody {
                print("movement vector", vector)
                entityIdComponent.angularVelocity = Vector(horizontal: vector.dx, vertical: vector.dy)
            }
        }
    }
}

extension ClientViewModel {
    func activateSkill(forEntity entity: Entity, skillId: String) {
        let entityId = entity.id
        guard let skillCasterComponent = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId) else {
            print("No SkillCaster component found for entity with ID: \(entityId)")
            return
        }
//        print("[ClientViewModel] \(skillId) queued for activation")
        skillCasterComponent.queueSkillActivation(skillId)
    }

    func getSkillIds(for entity: Entity) -> [String] {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)

        if let skillCasterIds = skillCaster?.skills.keys {
//            print("skill caster ids: ", Array(skillCasterIds))
            return Array(skillCasterIds)
        } else {
            return []
        }
    }

    func getSkills(for entity: Entity) -> [Dictionary<SkillID, any Skill>.Element] {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)

        if let skills = skillCaster?.skills {
//            print("skills", skills)
            return Array(skills)
        } else {
            return []
        }
    }

    func getSkillCooldowns(for entity: Entity) -> [SkillID: TimeInterval] {
        let entityId = entity.id
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)

        if let skillCooldowns = skillCaster?.skillCooldowns {
//            print("skillsCds", skillCooldowns)
            return skillCooldowns
        } else {
            return [:]
        }
    }
}

extension ClientViewModel {
    private var closingZoneShape: Shape? {
        let environmentalEffectComponents = gameWorld.entityComponentManager
            .getAllComponents(ofType: EnvironmentEffect.self)
        return environmentalEffectComponents.first?.environmentShape
    }

    var closingZoneCenter: CGPoint {
        guard let shape = closingZoneShape else {
            return .zero
        }
        return CGPoint(x: shape.center.xCoord, y: shape.center.yCoord)
    }

    var closingZoneRadius: CGFloat {
        guard let shape = closingZoneShape else {
            return 100000 // So no gas cloud at all
        }
        return shape.halfLength
    }
}

// TODO: Shift this to game over view model
extension ClientViewModel {
    func getAchivements() {
        let achievements = gameWorld.achievementManager.achievements
        let metricRepository = gameWorld.getRepository()

        metricRepository.notifyAllObservers(userID: currPlayerId)

        for achievement in achievements {
            if achievement.count >= 1 {
                print(achievement.title, achievement.description)
            }
        }
    }
}
