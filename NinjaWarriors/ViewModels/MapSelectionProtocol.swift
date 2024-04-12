//
//  MapSelectionProtocol.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 12/4/24.
//

import Foundation

protocol MapSelectionProtocol: ObservableObject {
    @MainActor var map: Map? { get set }
}
