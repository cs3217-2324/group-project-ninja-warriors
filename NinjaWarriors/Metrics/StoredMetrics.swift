//
//  StoredMetrics.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

struct StoredMetrics: Codable {
    var userID: UserID
    var metricsCounts: [String: Double]

    init(userID: UserID, metricsMap: [MetricType: (Metric, [MetricObserver])]) {
        self.userID = userID

        var storableMap: [String: Double] = [:]
        metricsMap.forEach { (_, metricAndObservers) in
            let (metric, _) = metricAndObservers
            let metricTypeString = NSStringFromClass(type(of: metric))
            storableMap[metricTypeString] = metric.value
        }
        self.metricsCounts = storableMap
    }

    func updateMetric(metric: inout Metric) {
        guard userID == metric.userID else { return }
        let metricTypeString = NSStringFromClass(type(of: metric))
        if let newCount = self.metricsCounts[metricTypeString] {
            metric.value = newCount
        }
    }
}
