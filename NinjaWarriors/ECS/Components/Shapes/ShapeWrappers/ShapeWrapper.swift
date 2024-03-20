//
//  ShapeWrapper.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation

struct ShapeWrapper: Codable {
    @CodableWrapper var center: PointWrapper
    @CodableWrapper var orientation: Double
    @CodableWrapper var halfLength: Double
    @CodableWrapper var edges: [LineWrapper]
    @CodableWrapper var vertices: [PointWrapper]

    init(center: PointWrapper, orientation: Double,
         halfLength: Double, edges: [LineWrapper], vertices: [PointWrapper]) {
        self.center = center
        self.orientation = orientation
        self.halfLength = halfLength
        self.edges = edges
        self.vertices = vertices
    }

    /*
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

    func encode<T: Codable>(_ object: T) -> String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(object)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding object: \(error)")
            return nil
        }
    }
    */

    /*
    struct MyStruct: Codable {
        @CodableWrapper var foo: String
        @CodableWrapper var bar: Int
    }

    func test() {
        let randomNonce = RandomNonce().randomNonceString()
        let shape = Shape(id: randomNonce,
                          entity: nil,
                          center: Point(xCoord: 10.0, yCoord: 10.0),
                          halfLength: Constants.defaultSize)

        let player = Player(id: "1", shape: shape)
        shape.entity = player

        /*
        let wrapper = CodableWrapper(value: shape)

        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(wrapper) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString ?? "Failed to encode JSON")
        }
        */
        //let shape = Shape(id: "123", entity: nil, center: Point(xCoord: 10.0, yCoord: 10.0), halfLength: 20.0)
        if let jsonString = encode(shape) {
            print(jsonString)
        }
    }
    */

    func toShape() -> Shape {
        let center = center.toPoint()
        var objectEdges: [Line] = []
        for edge in edges {
            objectEdges.append(edge.toLine())
        }
        var objectVertices: [Point] = []
        for vertex in vertices {
            objectVertices.append(vertex.toPoint())
        }
        return Shape(center: center, halfLength: halfLength,
                          orientation: orientation, edges: objectEdges, vertices: objectVertices)
    }
}

/*
class C {
    func test() {
        let myStruct = MyStruct(foo: "Hello", bar: 42)
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(myStruct) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString ?? "Failed to encode JSON")
        }
    }
}
*/
