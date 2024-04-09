//
//  ShapeWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct ShapeWrapper: Codable {
    var center: PointWrapper
    var offset: PointWrapper
    var orientation: Double
    var halfLength: Double
    var edges: [LineWrapper]
    var vertices: [PointWrapper]

    func toShape() -> Shape {
        let center = center.toPoint()
        let offset = offset.toPoint()
        var objectEdges: [Line] = []
        for edge in edges {
            objectEdges.append(edge.toLine())
        }
        var objectVertices: [Point] = []
        for vertex in vertices {
            objectVertices.append(vertex.toPoint())
        }
        return Shape(center: center, offset: offset, halfLength: halfLength,
                          orientation: orientation, edges: objectEdges, vertices: objectVertices)
    }
}
