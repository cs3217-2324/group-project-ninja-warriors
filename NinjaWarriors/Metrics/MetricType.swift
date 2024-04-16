//
//  MetricType.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

struct MetricType: Hashable {
    let type: Metric.Type

    init(_ type: Metric.Type) {
        self.type = type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

    static func ==(lhs: MetricType, rhs: MetricType) -> Bool {
        return lhs.type == rhs.type
    }
}
