//
//  NinjaWarriorsTests.swift
//  NinjaWarriorsTests
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import XCTest
@testable import NinjaWarriors

final class NinjaWarriorsTests: XCTestCase {

    func testSkillCasterActivatesSkillCorrectly() {
        // Setup
        let gameObject1 = GameObject(center: Point(xCoord: 150.0 + Double.random(in: -50.0...50.0),
                                                   yCoord: 150.0), halfLength: 25.0)
        let dashSkill = DashSkill()
        let player = Player(id: "1", gameObject: gameObject1, skills: [dashSkill]) // Adjust based on your actual Player init
        guard let skillCaster = player.skillCaster else {
            XCTFail("Player should have a SkillCaster component.")
            return
        }

        // Add the mock skill to the skill caster if not automatically added by Player init
        skillCaster.addSkill(dashSkill)

        // Activate the skill via SkillCaster
        skillCaster.activateSkill(withId: dashSkill.id)

        XCTAssertTrue(dashSkill.activated, "The skill should be activated.")

    }

}
