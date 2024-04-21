//
//  EntityViewModel.swift
//  NinjaWarriors
//
//  Created by Joshen on 7/4/24.
//

import Foundation
import Combine

class EntityViewModel: ObservableObject {
    @Published var components: [Component]
    @Published var currPlayerId: String

    init(components: [Component], currPlayerId: String) {
        self.components = components
        self.currPlayerId = currPlayerId
    }

    var transform: Transform? {
        components.first(where: { $0 is Transform }) as? Transform
    }

    var sprite: Sprite? {
        components.first(where: { $0 is Sprite }) as? Sprite
    }

    var health: Health? {
        components.first(where: { $0 is Health }) as? Health
    }

    var rigidbody: Rigidbody? {
        components.first(where: { $0 is Rigidbody }) as? Rigidbody
    }

    var dodge: Dodge? {
        components.first(where: { $0 is Dodge }) as? Dodge
    }

    var lifespan: Lifespan? {
        components.first(where: { $0 is Lifespan }) as? Lifespan
    }

    var position: CGPoint {
        rigidbody?.position.get() ?? CGPoint(x: 0, y: 0)
    }

    var rotation: Double {
        rigidbody?.rotation ?? 0.0
    }

    var opacity: Double {
        guard let lifespan = lifespan else { return 1.0 }
        let remainingLifespan = max(lifespan.lifespan - lifespan.elapsedTime, 0)
        return Double(remainingLifespan / max(lifespan.lifespan, 1))
    }

    var gemCount: Int {
        guard let collector = components.first(where: { $0 is Collector }) as? Collector else {
            return 0
        }
        return collector.countItem(of: "Gem")
    }
}
