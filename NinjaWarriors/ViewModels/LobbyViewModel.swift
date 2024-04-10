//
//  LobbyViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 16/3/24.
//

import Foundation
import SwiftUI

@MainActor
final class LobbyViewModel: ObservableObject {
    @Published private(set) var matches: [Match] = []
    @Published private(set) var matchManager: MatchManager
    @Published private(set) var realTimeManager: RealTimeManagerAdapter?
    @Published var matchId: String?
    @Published var playerIds: [String]?
    @Published var hostId: String?
    @Published var userId: String?
    let signInViewModel: SignInViewModel
    let isGuest: Bool
    let guestId: String = RandomNonce().randomNonceString()

    init() {
        matchManager = MatchManagerAdapter()
        self.signInViewModel = SignInViewModel()
        isGuest = true
    }

    init(signInViewModel: SignInViewModel) {
        matchManager = MatchManagerAdapter()
        self.signInViewModel = signInViewModel
        isGuest = false
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
        initEntities(ids: playerIds)
    }

    // Add all relevant initial entities here
    func initEntities(ids playerIds: [String]?) {
        initObstacles()

        guard let playerIds = playerIds else {
            return
        }
        initPlayers(ids: playerIds)

        addClosingZone(center: Constants.closingZonePosition, radius: Constants.closingZoneRadius)
    }

    func getUserId() -> String {
        guard let signInUserId = signInViewModel.getUserId() else {
            return guestId
        }
        return signInUserId
    }

    func selectHost(from ids: [String]?) {
        guard let ids = ids else {
            return
        }
        hostId = ids.first
    }

    func initObstacles() {
        let obstaclePositions: [Point] = getObstaclePositions()
        for index in 0..<Constants.obstacleCount {
            addObstacleToDatabase(at: obstaclePositions[index])
        }
    }

    func initPlayers(ids playerIds: [String]) {
        let playerPositions: [Point] = getPlayerPositions()

        for (index, playerId) in playerIds.enumerated() {
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
                                      entity: player, skills: [SlashAOESkill(id: "slash", cooldownDuration: 8.0),
                                                             DashSkill(id: "dash", cooldownDuration: 8.0),
                                                             DodgeSkill(id: "dodge", cooldownDuration: 8.0),
                                                            RefreshCooldownsSkill(id: "refresh", cooldownDuration: 30.0)])

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(), entity: player,
                                     image: "player-icon", width: 100.0, height: 100.0, health: 100,
                                     maxHealth: 100)

        let health = Health(id: RandomNonce().randomNonceString(), entity: player,
                                entityInflictDamageMap: [:], health: 100, maxHealth: 100)

        let score = Score(id: RandomNonce().randomNonceString(), entity: player,
                          score: 0, entityGainScoreMap: [:])

        let dodge = Dodge(id: RandomNonce().randomNonceString(), entity: player, isEnabled: false, invulnerabilityDuration: 2.0)

        let components = [playerRigidbody, playerCollider, skillCaster, spriteComponent, health, score, dodge]
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: player, components: components)
        }
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

    private func addObstacleToDatabase(at position: Point) {
        let obstacle = makeObstacle(at: position)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: obstacle)
        }
    }

    private func makeObstacle(at position: Point) -> Obstacle {
        Obstacle(id: RandomNonce().randomNonceString(), position: position)
    }

    private func addClosingZone(center: Point, radius: Double) {
        let closingZone = makeClosingZone(center: center, radius: radius)
        guard let realTimeManager = realTimeManager else {
            return
        }
        Task {
            try? await realTimeManager.uploadEntity(entity: closingZone, components: closingZone.getInitializingComponents())
        }
    }

    private func makeClosingZone(center: Point, radius: Double) -> ClosingZone {
        ClosingZone(id: RandomNonce().randomNonceString(), center: center, initialRadius: radius)
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

extension LobbyViewModel {
    func getPlayerPositions() -> [Point] {
        Constants.playerPositions
    }

    func getObstaclePositions() -> [Point] {
        let screenWidth = Constants.screenWidth
        let screenHeight = Constants.screenHeight
        let obstacleCount = Constants.obstacleCount

        let center = Point(xCoord: screenWidth / 2, yCoord: screenHeight / 2)
        let radius: Double = 200
        let gapAngle: Double = 2.5 * .pi / Double(obstacleCount)
        var positions: [Point] = []

        for i in 0..<obstacleCount {
            let angle = Double(i) * gapAngle
            let x = center.xCoord + radius * cos(angle)
            let y = center.yCoord + radius * sin(angle)
            positions.append(Point(xCoord: x, yCoord: y))
        }
        return positions
    }
}
