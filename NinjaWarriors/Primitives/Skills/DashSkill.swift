//
//  DashSkill.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 19/3/24.
//

import Foundation

class DashSkill: MovementSkill {
    var id: SkillID
    var cooldownDuration: TimeInterval
    
    required init(id: SkillID) {
        self.id = id
        self.cooldownDuration = 0
    }
    
    convenience init(id: SkillID, cooldownDuration: TimeInterval) {
        self.init(id: id)
        self.cooldownDuration = cooldownDuration
    }
    
    func activate(from entity: Entity, in manager: EntityComponentManager) {
        performMovement(on: entity, in: manager)
    }
    
    func performMovement(on target: Entity, in manager: EntityComponentManager) {
        // TODO: Add movement vector to GameWorld similar to how joystick so that can check for collision
        print("[DashSkill] Activated on \(target)")
        //        let currCenter = target.shape.getCenter()
        //
        //        target.shape.center.setCartesian(xCoord: currCenter.x, yCoord: currCenter.y + 100)
    }
    
    func wrapper() -> SkillWrapper {
        return SkillWrapper(id: id, type: "DashSkill", cooldownDuration: cooldownDuration)
    }
}
