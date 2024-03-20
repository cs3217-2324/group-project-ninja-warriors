//
//  TransformHandler.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 20/3/24.
//

import Foundation

// TODO: Only add entities with shape to manager, do not add all entities
class TransformHandler: System {
    var manager: EntityComponentManager?

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func transformPosition(for id: EntityID, to position: Point) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id) else {
            return
        }
        transformComponent.position = position
    }

    func transformSize(for id: EntityID, to halfLength: Double) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id) else {
            return
        }
        transformComponent.shape.halfLength = halfLength
    }

    func transformOrientation(for id: EntityID, to orientation: Double) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id) else {
            return
        }
        transformComponent.shape.orientation = orientation
    }

    func transformEdges(for id: EntityID, add edge: Line) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id),
              var transformComponentEdges = transformComponent.shape.edges else {
            return
        }
        transformComponentEdges.append(edge)
    }

    func transformEdges(for id: EntityID, remove edge: Line) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id),
              var transformComponentEdges = transformComponent.shape.edges else {
            return
        }
        if let index = transformComponentEdges.firstIndex(of: edge) {
            transformComponentEdges.remove(at: index)
        }
    }

    func transformVertices(for id: EntityID, add vertex: Point) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id),
              var transformComponentVertices = transformComponent.shape.vertices else {
            return
        }
        transformComponentVertices.append(vertex)
    }

    func transformVertices(for id: EntityID, remove vertex: Point) {
        guard let transformComponent = manager?.getComponentFromId(ofType: TransformComponent.self, of: id),
              var transformComponentVertices = transformComponent.shape.vertices else {
            return
        }
        if let index = transformComponentVertices.firstIndex(of: vertex) {
            transformComponentVertices.remove(at: index)
        }
    }
}
