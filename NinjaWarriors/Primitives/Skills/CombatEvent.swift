//
//  CombatEvent.swift
//  NinjaWarriors
//
//  Created by Joshen on 15/4/24.
//

import Foundation

struct CombatEvent {
    var target: Entity
    var amount: Double
    var type: EventType
}

enum EventType {
    case damage
    case heal
}
