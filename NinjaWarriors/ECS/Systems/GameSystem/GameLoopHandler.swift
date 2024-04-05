//
//  GameLoopHandler.swift
//  NinjaWarriors
//
//  Created by Joshen Lim on 20/3/24.
//

import Foundation
import SwiftUI

// Game Loop using CADisplayLink adapted for SwiftUI
class GameLoopManager {
    var displayLink: CADisplayLink?
    var lastUpdateTime: TimeInterval = 0
    let updateInterval: TimeInterval = 1.0 / 30.0  // Update at 60 FPS
    var onUpdate: ((TimeInterval) -> Void)?

    func start() {
        lastUpdateTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(loop))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc func loop() {
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastUpdateTime

        if deltaTime >= updateInterval {
            lastUpdateTime = currentTime
            onUpdate?(deltaTime)
        }
    }
}
