//
//  ShapeWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

/*
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
*/


struct ShapeWrapper: Codable {
    var center: PointWrapper
    var offset: PointWrapper
    var orientation: Double
    var halfLength: Double
    var edges: [LineWrapper] = []
    var vertices: [PointWrapper] = []

    init(center: PointWrapper, offset: PointWrapper, orientation: Double, halfLength: Double,
         edges: [LineWrapper], vertices: [PointWrapper]) {
        self.center = center
        self.offset = offset
        self.orientation = orientation
        self.halfLength = halfLength
        self.edges = edges
        self.vertices = vertices
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(center, forKey: AnyCodingKey(stringValue: "center"))
        try container.encode(offset, forKey: AnyCodingKey(stringValue: "offset"))
        try container.encode(orientation, forKey: AnyCodingKey(stringValue: "orientation"))
        try container.encode(halfLength, forKey: AnyCodingKey(stringValue: "halfLength"))
        try container.encode(edges, forKey: AnyCodingKey(stringValue: "edges"))
        try container.encode(vertices, forKey: AnyCodingKey(stringValue: "vertices"))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        center = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "center"))
        offset = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "offset"))
        orientation = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "orientation"))
        halfLength = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "halfLength"))

        do {
            edges = try container.decode([LineWrapper].self, forKey: AnyCodingKey(stringValue: "edges"))
        } catch {
            edges = []
        }

        do {
            vertices = try container.decode([PointWrapper].self, forKey: AnyCodingKey(stringValue: "vertices"))
        } catch {
            vertices = []
        }
    }

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
