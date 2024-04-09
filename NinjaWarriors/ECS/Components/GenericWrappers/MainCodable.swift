//
//  MainCodable.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 23/3/24.
//

import Foundation

protocol MainCodable: Codable {}

extension MainCodable {
    static var typeName: String { String(describing: Self.self) }
    var typeName: String { Self.typeName }
}

/// Convert string to type. didn't find way to convert non reference types from string
/// You can register any type by using register function
struct TypeHelper {
    private static var availableTypes: [String: Any.Type] = [:]
    private static var module = String(reflecting: TypeHelper.self).components(separatedBy: ".")[0]

    static func typeFrom(name: String) -> Any.Type? {
        if let type = availableTypes[name] {
            return type
        }
        return _typeByName("\(module).\(name)")
    }

    static func register(type: Any.Type) {
        availableTypes[String(describing: type)] = type
    }
}

// TODO: Remove enum case
@propertyWrapper
struct AnyMainCodable<T>: Codable, CustomDebugStringConvertible {
    private struct Container: Codable, CustomDebugStringConvertible {
        let data: MainCodable

        enum CodingKeys: CodingKey {
            case className
        }

        init?(data: Any) {
            guard let data = data as? MainCodable else { return nil }
            self.data = data
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let name = try container.decode(String.self, forKey: .className)

            guard let type = TypeHelper.typeFrom(name: name) as? MainCodable.Type else {
                throw DecodingError
                    .valueNotFound(String.self,
                                   .init(codingPath: decoder.codingPath, debugDescription: "invalid type \(name)"))
            }
            data = try type.init(from: decoder)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(data.typeName, forKey: .className)
            try data.encode(to: encoder)
        }

        var debugDescription: String {
            "\(data)"
        }
    }

    var wrappedValue: [T] {
        get { containers.map { $0.data as? T } }
        set { containers = newValue.compactMap({ Container(data: $0) }) }
    }

    private var containers: [Container]

    init(wrappedValue: [T]) {
        if let item = wrappedValue.first(where: { !($0 is MainCodable) }) {
            fatalError("unsupported type: \(type(of: item)) (\(item))")
        }
        self.containers = wrappedValue.compactMap({ Container(data: $0) })
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.containers = try container.decode([Container].self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(containers)
    }

    var debugDescription: String {
        "\(wrappedValue)"
    }
}
