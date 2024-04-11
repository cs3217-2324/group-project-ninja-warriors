//
//  SinglePlayerViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

@MainActor
final class SinglePlayerViewModel: ObservableObject {
    @Published private(set) var realTimeManager: RealTimeManagerAdapter?
    @Published var matchId: String = RandomNonce().randomNonceString()
    @Published var playerIds = ["singlePlayer", "dummyPlayer1", "dummyPlayer2", "dummyPlayer3"]
    @Published var hostId = "singlePlayer"
    var character = "Shadowstrike"
    // TODO: Accept map from map selection nav view
    @Published var map: Map?

    init() {
        realTimeManager = RealTimeManagerAdapter(matchId: matchId)
        map = GemMap(manager: RealTimeManagerAdapter(matchId: matchId))
    }

    func start() {
        initPlayers(ids: playerIds)
        map?.startMap()
    }

    func getCharacterSkills() -> [Skill] {
        Constants.characterSkills[character] ?? Constants.defaultSkills
    }

    // MARK: Player
    func getPlayerPositions() -> [Point] {
        Constants.playerPositions
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
                                      entity: player, skills: getCharacterSkills())

        // TODO: Map image to top-down images after finding top down images
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
}
