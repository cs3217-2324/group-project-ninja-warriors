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
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id) else {
            return
        }
        shapeComponent.center = position
    }

    func transformSize(for id: EntityID, to halfLength: Double) {
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id) else {
            return
        }
        shapeComponent.halfLength = halfLength
    }

    func transformOrientation(for id: EntityID, to orientation: Double) {
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id) else {
            return
        }
        shapeComponent.orientation = orientation
    }

    func transformEdges(for id: EntityID, add edge: Line) {
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id),
              var shapeComponentEdges = shapeComponent.edges else {
            return
        }
        shapeComponentEdges.append(edge)
    }

    func transformEdges(for id: EntityID, remove edge: Line) {
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id),
              var shapeComponentEdges = shapeComponent.edges else {
            return
        }
        if let index = shapeComponentEdges.firstIndex(of: edge) {
            shapeComponentEdges.remove(at: index)
        }
    }

    func transformVertices(for id: EntityID, add vertex: Point) {
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id),
              var shapeComponentVertices = shapeComponent.vertices else {
            return
        }
        shapeComponentVertices.append(vertex)
    }

    func transformVertices(for id: EntityID, remove vertex: Point) {
        guard let shapeComponent = manager?.getComponentFromId(ofType: Shape.self, of: id),
              var shapeComponentVertices = shapeComponent.vertices else {
            return
        }
        if let index = shapeComponentVertices.firstIndex(of: vertex) {
            shapeComponentVertices.remove(at: index)
        }
    }
}
