//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Entity {
    var id: EntityID
    private(set) var skillCaster: SkillCaster?
    var gameObject: GameObject

    init(id: String, gameObject: GameObject, skills: [Skill]) {
        self.id = id
        self.gameObject = gameObject
        self.skillCaster = SkillCaster(id: "1", entity: self, skills: skills) // TODO: fix hardcode id
    }

    func getInitializingComponents() -> [Component] {
        guard let skillCaster = skillCaster else { return [] }
        return [skillCaster]
    }

    func getPosition() -> CGPoint {
        gameObject.getCenter()
    }

    func changePosition(to center: Point) {
        gameObject.center = center
    }

    func toPlayerWrapper() -> PlayerWrapper {
        PlayerWrapper(id: id, gameObject: gameObject.toGameObjectWrapper())
    }
}
