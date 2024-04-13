//
//  CharacterSelection.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 12/4/24.
//

import Foundation

protocol CharacterSelection: ObservableObject {
    @MainActor var character: String { get set }
}
