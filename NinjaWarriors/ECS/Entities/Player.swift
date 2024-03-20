//
//  Player.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

class Player: Equatable, Entity {
    var id: EntityID
    private(set) var skillCaster: SkillCaster?
    var shape: Shape

    init(id: String, Shape: Shape, skills: [Skill]) {
        self.id = id
        self.shape = Shape
        self.skillCaster = SkillCaster(id: "1", entity: self, skills: skills) // TODO: fix hardcode id
    }

    func getInitializingComponents() -> [Component] {
        guard let skillCaster = skillCaster else { return [] }
        return [skillCaster]
    }

    func getPosition() -> CGPoint {
        shape.getCenter()
    }

    func changePosition(to center: Point) {
        shape.center = center
    }

    func toPlayerWrapper() -> PlayerWrapper {
        PlayerWrapper(id: id, shape: shape.toShapeWrapper())
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
