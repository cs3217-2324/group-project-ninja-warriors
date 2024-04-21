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

    init(userID: UserID, userMetrics: [UserID: [MetricType: (Metric, [MetricObserver])]]) {
        self.userID = userID

        guard let metricsMap = userMetrics[userID] else {
            self.metricsCounts = [:]
            return
        }

        var storableMap: [String: Double] = [:]
        metricsMap.forEach { (_, metricAndObservers) in
            let (metric, _) = metricAndObservers
            let metricTypeString = NSStringFromClass(type(of: metric))
            storableMap[metricTypeString] = metric.value
        }
        self.metricsCounts = storableMap
    }

    func updateMetricsFromStoredValues(userMetricsMap: inout [UserID: [MetricType: (Metric, [MetricObserver])]]) {
        guard var metricsMap: [MetricType: (Metric, [MetricObserver])] = userMetricsMap[userID] else {
            return
        }
        let newMetricsMap = metricsMap.mapValues { (metric, observers) in
            let metricTypeString = NSStringFromClass(type(of: metric))
            if let storedValue = metricsCounts[metricTypeString] {
                metric.value = storedValue
            }
            return (metric, observers)
        }
        userMetricsMap[userID] = newMetricsMap
    }
}
