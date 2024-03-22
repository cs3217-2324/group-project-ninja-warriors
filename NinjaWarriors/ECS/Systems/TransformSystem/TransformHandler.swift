//
//  TransformHandler.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 20/3/24.
//

import Foundation

class TransformHandler: System {
    var manager: EntityComponentManager?
    // To untransform if collision detected
    var prevPosition: Point?
    var prevHalfLength: Double?
    var prevOrientation: Double?

    required init(for manager: EntityComponentManager) {
        self.manager = manager
    }

    func update(after time: TimeInterval) { }

    func transformPosition(for id: EntityID, to position: Point) {
        guard let shape = manager?.entity(with: id)?.shape else {
            return
        }
        prevPosition = shape.center
        shape.center = position
    }

    func transformSize(for id: EntityID, to halfLength: Double) {
        guard let shape = manager?.entity(with: id)?.shape else {
            return
        }
        prevHalfLength = shape.halfLength
        shape.halfLength = halfLength
    }

    func transformOrientation(for id: EntityID, to orientation: Double) {
        guard let shape = manager?.entity(with: id)?.shape else {
            return
        }
        prevOrientation = shape.orientation
        shape.orientation = orientation
    }

    func transformEdges(for id: EntityID, add edge: Line) {
        guard let shape = manager?.entity(with: id)?.shape,
              var shapeEdges = shape.edges else {
            return
        }
        shapeEdges.append(edge)
    }

    func transformEdges(for id: EntityID, remove edge: Line) {
        guard let shape = manager?.entity(with: id)?.shape,
              var shapeEdges = shape.edges else {
            return
        }
        if let index = shapeEdges.firstIndex(of: edge) {
            shapeEdges.remove(at: index)
        }
    }

    func transformVertices(for id: EntityID, add vertex: Point) {
        guard let shape = manager?.entity(with: id)?.shape,
              var shapeVertices = shape.vertices else {
            return
        }
        shapeVertices.append(vertex)
    }

    func transformVertices(for id: EntityID, remove vertex: Point) {
        guard let shape = manager?.entity(with: id)?.shape,
              var shapeVertices = shape.vertices else {
            return
        }
        if let index = shapeVertices.firstIndex(of: vertex) {
            shapeVertices.remove(at: index)
        }
    }
}
