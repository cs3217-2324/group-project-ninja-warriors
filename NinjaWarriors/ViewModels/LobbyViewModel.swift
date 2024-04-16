//
//  LobbyViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

@MainActor
final class LobbyViewModel: MapSelection, CharacterSelection {
    @Published private(set) var matches: [Match] = []
    @Published private(set) var matchManager: MatchManager
    @Published private(set) var realTimeManager: RealTimeManagerAdapter?
    @Published var matchId: String?
    @Published var playerIds: [String]?
    @Published var hostId: String?
    @Published var userId: String?
    @Published var map: Map = GemMap()
    @Published var ownEntities: [Entity] = []
    var character = "Shadowstrike"
    let signInViewModel: SignInViewModel
    let isGuest: Bool
    let guestId: String = RandomNonce().randomNonceString()
    var metricsRepository: MetricsRepository
    var achievementsManager: AchievementManager

    // Guest mode
    init() {
        matchManager = MatchManagerAdapter()
        self.signInViewModel = SignInViewModel()
        self.metricsRepository = MetricsRepository()
        self.achievementsManager = AchievementManager(userID: guestId, metricsSubject: self.metricsRepository)
        isGuest = true
    }

    // Login mode
    init(signInViewModel: SignInViewModel) {
        matchManager = MatchManagerAdapter()
        self.signInViewModel = signInViewModel
        self.metricsRepository = MetricsRepository()
        self.achievementsManager = AchievementManager(userID: signInViewModel.getUserId() ?? guestId, metricsSubject: metricsRepository)
        isGuest = false
    }

    func getUserId() -> String {
        guard let signInUserId = signInViewModel.getUserId() else {
            return guestId
        }
        return signInUserId
    }

    func ready(userId: String) {
        Task { [unowned self] in
            let newMatchId = try await matchManager.enterQueue(playerId: userId)
            self.matchId = newMatchId
            addListenerForMatches()
        }
    }

    func unready(userId: String) {
        guard let match = matchId else {
            return
        }
        Task { [unowned self] in
            await self.matchManager.removePlayerFromMatch(playerId: userId, matchId: match)
        }
    }

    func start() async {
        guard let matchId = matchId else {
            return
        }
        realTimeManager = RealTimeManagerAdapter(matchId: matchId)
        do {
            playerIds = try await matchManager.startMatch(matchId: matchId)
        } catch {
            print("Error starting match: \(error)")
        }
        selectHost(from: playerIds)
        initPlayer(ids: playerIds)
        initMapEntities()
    }

    func selectHost(from ids: [String]?) {
        guard let ids = ids else {
            return
        }
        hostId = ids.first
    }

    // MARK: Player
    func getPlayerPositions() -> [Point] {
        Constants.playerPositions
    }

    func getCharacterSkills() -> [Skill] {
        Constants.characterSkills[character] ?? Constants.defaultSkills
    }

    private func makePlayer(id playerId: String, at position: Point) -> Player {
        Player(id: playerId, position: position)
    }

    func getPlayerCount() -> Int? {
        if let match = matches.first(where: { $0.id == matchId }) {
            return match.count
        }
        return nil
    }

    func initPlayer(ids playerIds: [String]?) {
        guard let playerIds = playerIds else {
            return
        }
        let playerPositions: [Point] = getPlayerPositions()
        let playerId = getUserId()
        for (index, currPlayerId) in playerIds.enumerated() where currPlayerId == playerId {
            addPlayerToDatabase(id: playerId, at: playerPositions[index])
        }
    }

    private func addPlayerToDatabase(id playerId: String, at position: Point) {
        let player = makePlayer(id: playerId, at: position)
        let shape = Shape(center: position, halfLength: Constants.defaultSize)

        let playerCollider = Collider(id: RandomNonce().randomNonceString(), entity: player,
                                      colliderShape: shape, collidedEntities: [],
                                      isColliding: false, isOutOfBounds: false)

        let playerRigidbody = Rigidbody(id: RandomNonce().randomNonceString(), entity: player,
                                        angularDrag: 0.0, angularVelocity: Vector.zero, mass: 8.0,
                                        rotation: 0.0, totalForce: Vector.zero, inertia: 0.0,
                                        position: shape.center, velocity: Vector.zero,
                                        attachedCollider: playerCollider)

        let skillCaster = SkillCaster(id: RandomNonce().randomNonceString(),
                                      entity: player, skills: getCharacterSkills())

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(), entity: player,
                                     image: character + "-top", width: 100.0, height: 100.0)

        let health = Health(id: RandomNonce().randomNonceString(), entity: player,
                            entityInflictDamageMap: [:], health: 100, maxHealth: 100)

        let score = Score(id: RandomNonce().randomNonceString(), entity: player,
                          score: 0, entityGainScoreMap: [:])

        let dodge = Dodge(id: RandomNonce().randomNonceString(), entity: player,
                          isEnabled: false, invulnerabilityDuration: 2.0)

        let components = [playerRigidbody, playerCollider, skillCaster, spriteComponent, health, score, dodge]
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: player, components: components)
        }

        ownEntities.append(player)
    }

    // MARK: Map
    func initMapEntities() {
        guard let realTimeManager = realTimeManager, hostId == getUserId() else {
            return
        }

        let mapEntities: [Entity] = map.getMapEntities()

        for mapEntity in mapEntities {
            Task {
                try? await realTimeManager.uploadEntity(entity: mapEntity,
                                                        components: mapEntity.getInitializingComponents())
            }
        }
    }

    func addListenerForMatches() {
        let publisher = matchManager.addListenerForAllMatches()
        publisher.subscribe(update: { [unowned self] matches in
            self.matches = matches.map { $0.toMatch() }
        }, error: { error in
            print(error)
        })
    }
}
