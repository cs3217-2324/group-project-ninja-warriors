//
//  MapSelection.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 12/4/24.
//

import Foundation

protocol MapSelection: ObservableObject {
    @MainActor var map: Map { get set }
}
