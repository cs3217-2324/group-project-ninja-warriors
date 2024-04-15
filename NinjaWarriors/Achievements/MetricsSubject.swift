//
//  MetricsSubject.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 14/4/24.
//

import Foundation

protocol MetricsSubject: AnyObject {
    func addObserver<T: Metric>(_ observer: MetricObserver, for metricType: T.Type, userID: UserID)
    func removeObserver<T: Metric>(_ observer: MetricObserver, for metricType: T.Type, userID: UserID)
    func initializeMetricForUser<T: Metric>(metricType: T.Type, userID: UserID)
}

extension MetricsRepository: MetricsSubject {
    func addObserver<T: Metric>(_ observer: MetricObserver, for metricType: T.Type, userID: UserID) {
        self.registerObserverForUser(observer, for: metricType, userID: userID)
    }

    func removeObserver<T: Metric>(_ observer: MetricObserver, for metricType: T.Type, userID: UserID) {
        self.removeObserverForUser(observer, for: metricType, userID: userID)
    }

    func initializeMetricForUser<T>(metricType: T.Type, userID: UserID) where T: Metric {
        self.createMetricsMap(for: userID)
        self.addMetricForUser(metricType: metricType, for: userID)
    }
}
