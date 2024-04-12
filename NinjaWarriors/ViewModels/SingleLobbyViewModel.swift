//
//  SingleLobbyViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

@MainActor
final class SingleLobbyViewModel: MapSelectionProtocol {
    @Published private(set) var realTimeManager: RealTimeManagerAdapter?
    @Published var matchId: String = RandomNonce().randomNonceString()
    @Published var playerIds = ["singlePlayer", "dummyPlayer1", "dummyPlayer2", "dummyPlayer3"]
    @Published var hostId = "singlePlayer"
    var character = "Shadowstrike"
    @Published var map: Map?
    @Published var mapName: String?

    init() {
        realTimeManager = RealTimeManagerAdapter(matchId: matchId)
    }

    func start() {
        initPlayers(ids: playerIds)
        initMapEntities()
    }

    // MARK: Player
    private func getCharacterSkills() -> [Skill] {
        Constants.characterSkills[character] ?? Constants.defaultSkills
    }

    private func getPlayerPositions() -> [Point] {
        Constants.playerPositions
    }

    private func makePlayer(id playerId: String, at position: Point) -> Player {
        Player(id: playerId, position: position)
    }

    private func initPlayers(ids playerIds: [String]) {
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

        let spriteComponent = Sprite(id: RandomNonce().randomNonceString(), entity: player,
                                     image: character + "-top", width: 100.0, height: 100.0, health: 100,
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

    // MARK: Map
    private func initMapEntities() {
        guard let map = map, let realTimeManager = realTimeManager else {
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
}
