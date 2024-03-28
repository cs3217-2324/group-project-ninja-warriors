//
//  CanvasViewModel.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

@MainActor
final class CanvasViewModel: ObservableObject {
    @Published var gameWorld = GameWorld()
    @Published private(set) var entities: [Entity] = []
    @Published private(set) var manager: RealTimeManagerAdapter
    @Published private(set) var matchId: String
    @Published private(set) var currPlayerId: String
    @Published private(set) var position: CGPoint?

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.currPlayerId = currPlayerId
        manager = RealTimeManagerAdapter(matchId: matchId)

        gameWorld.start()
        gameWorld.updateViewModel = { [unowned self] in
            Task {
                await self.updateViewModel()
            }
        }
    }

    func updateViewModel() async {
        // TODO: Tidy up to obey law of demeter
        //print(gameWorld.entityComponentManager.getComponentFromId(ofType: Rigidbody.self, of: currPlayerId)?.position)

        position = gameWorld.entityComponentManager.getComponentFromId(ofType: Rigidbody.self, of: currPlayerId)?.position.get()

        await publishData()
    }

    func addListeners() {
        Task { [unowned self] in
            if let allEntities = try await self.manager.getAllEntities() {
                self.entities = allEntities
            }

            let publishers = self.manager.addPlayerListeners()
            for publisher in publishers {
                publisher.subscribe(update: { [unowned self] entities in
                    self.entities = entities.compactMap { $0.toEntity() }
                }, error: { error in
                    print(error)
                })
            }
            addEntitiesToWorld()
        }
    }

    func addEntitiesToWorld() {
        for entity in entities {
            gameWorld.entityComponentManager.add(entity: entity)
        }
    }

    // TODO: Find a way to obey law of demeter
    func publishData() async {
        guard let foundEntity = entities.first(where: { $0.id == currPlayerId }) else {
            print("No entity found with ID: \(currPlayerId)")
            return
        }

        try? await manager.uploadEntity(entity: foundEntity, entityName: "Player", component: gameWorld.entityComponentManager.getComponentFromId(ofType: Rigidbody.self, of: currPlayerId))

    }
}

extension CanvasViewModel {
    func activateSkill(forEntityWithId entityId: String, skillId: String) {
        guard let skillCasterComponent = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId) else {
            print("No SkillCaster component found for entity with ID: \(entityId)")
            return
        }
//        print("[CanvasViewModel] \(skillId) queued for activation")
        skillCasterComponent.queueSkillActivation(skillId)
    }

    func getSkillIds(for entityId: String) -> [String] {
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)
        
        if let skillCasterIds = skillCaster?.skills.keys {
//            print("skill caster ids: ", Array(skillCasterIds))
            return Array(skillCasterIds)
        } else {
            return []
        }
    }
    
    func getSkills(for entityId: String) -> [Dictionary<SkillID, any Skill>.Element] {
        let skillCaster = gameWorld.entityComponentManager
            .getComponentFromId(ofType: SkillCaster.self, of: entityId)
        
        if let skills = skillCaster?.skills {
            return Array(skills)
        } else {
            return []
        }
    }
}
