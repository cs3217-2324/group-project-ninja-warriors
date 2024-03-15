//
//  GameObjectWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

struct GameObjectWrapper: Codable {
    var center: PointWrapper
    var orientation: Double
    var halfLength: Double
    var edges: [LineWrapper]
    var vertices: [PointWrapper]

    init(center: PointWrapper, orientation: Double, halfLength: Double, edges: [LineWrapper], vertices: [PointWrapper]) {
        self.center = center
        self.orientation = orientation
        self.halfLength = halfLength
        self.edges = edges
        self.vertices = vertices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        center = try container.decode(PointWrapper.self, forKey: AnyCodingKey(stringValue: "center"))
        orientation = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "orientation"))
        halfLength = try container.decode(Double.self, forKey: AnyCodingKey(stringValue: "halfLength"))
        edges = try container.decode([LineWrapper].self, forKey: AnyCodingKey(stringValue: "edges"))
        vertices = try container.decode([PointWrapper].self, forKey: AnyCodingKey(stringValue: "vertices"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(center, forKey: AnyCodingKey(stringValue: "center"))
        try container.encode(orientation, forKey: AnyCodingKey(stringValue: "orientation"))
        try container.encode(halfLength, forKey: AnyCodingKey(stringValue: "halfLength"))
        try container.encode(edges, forKey: AnyCodingKey(stringValue: "edges"))
        try container.encode(vertices, forKey: AnyCodingKey(stringValue: "vertices"))
    }

    func toGameObject() -> GameObject {
        let center = center.toPoint()
        var objectEdges: [Line] = []
        for edge in edges {
            objectEdges.append(edge.toLine())
        }
        var objectVertices: [Point] = []
        for vertex in vertices {
            objectVertices.append(vertex.toPoint())
        }
        return GameObject(center: center, halfLength: halfLength, orientation: orientation, edges: objectEdges, vertices: objectVertices)
    }
}
