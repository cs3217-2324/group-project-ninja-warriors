//
//  EntityMetricsRecorder.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 14/4/24.
//

import Foundation

protocol EntityMetricsRecorder {
    var matchID: String { get }
    func record<T: Metric>(_ metricType: T.Type, forEntityID entityID: EntityID, value: Double)
    func resetAllMetrics(forEntityIDs entityIDs: [EntityID])
}
