//
//  MetricsRepository.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 10/4/24.
//

import Foundation

class MetricsRepository {
    typealias MetricsAndObserversMap = [MetricType: (Metric, [MetricObserver])]
    typealias UserMetricsMap = [UserID: MetricsAndObserversMap]

    private var userMetrics: UserMetricsMap

    init() {
        // TODO: probably initialize from some online thing
        self.userMetrics = UserMetricsMap()
    }

    func createMetricsMap(for userID: UserID) {
        guard self.userMetrics[userID] == nil else {
            return
        }
        self.userMetrics[userID] = MetricsAndObserversMap()
    }

    func addMetricForUser<T: Metric>(metricType: T.Type, for userID: UserID) {
        guard var metricsAndObserversMap = self.userMetrics[userID] else {
            self.createMetricsMap(for: userID)
            self.addMetricForUser(metricType: metricType, for: userID)
            return
        }

        let metricTypeKey = MetricType(metricType)
        metricsAndObserversMap[metricTypeKey] = (metricType.init(userID: userID), [])
        self.userMetrics[userID] = metricsAndObserversMap
    }

    func readMetric<T: Metric>(_ metricType: T.Type, userID: UserID) -> T? {
        guard let metricsAndObserversMap = userMetrics[userID] else {
            return nil
        }

        let metricTypeKey = MetricType(metricType)
        guard let (metric, _) = metricsAndObserversMap[metricTypeKey] else {
            return nil
        }

        guard let typedMetric = metric as? T else {
            return nil
        }

        return typedMetric
    }

    /// Updates the given metric for the user for the given game. If the metric isn't already being recorded, it is added
    func updateMetrics<T: Metric>(_ metricType: T.Type, userID: UserID, inGame gameID: GameID?, withValue value: Double) {
        guard var metricsAndObserversMap = self.userMetrics[userID] else {
            self.createMetricsMap(for: userID)
            self.updateMetrics(metricType, userID: userID, inGame: gameID, withValue: value)
            return
        }

        let metricTypeKey = MetricType(metricType)

        guard let (metric, observers) = metricsAndObserversMap[metricTypeKey] else {
            metricsAndObserversMap[metricTypeKey] = (metricType.init(userID: userID), [])
            self.userMetrics[userID] = metricsAndObserversMap
            self.updateMetrics(metricType, userID: userID, inGame: gameID, withValue: value)
            return
        }

        metric.update(with: value, for: gameID)

        notifyObservers(observers: observers, changedMetric: metric)
    }

    func updateMetrics<T: Metric>(_ metricType: T.Type, for userID: UserID, withValue value: Double) {
        self.updateMetrics(metricType, userID: userID, inGame: nil, withValue: value)
    }

    func notifyObservers(observers: [MetricObserver], changedMetric: Metric) {
        for observer in observers {
            observer.notify(changedMetric)
        }
    }

    func registerMetricsForUser<T: Metric>(metricTypes: [T.Type], for userID: UserID) {
        guard userMetrics[userID] == nil else {
            return
        }
        var userMetricsMap = MetricsAndObserversMap()
        for metricType in metricTypes {
            let metricTypeKey = MetricType(metricType)
            userMetricsMap[metricTypeKey] = (metricType.init(userID: userID), [])
        }
        userMetrics[userID] = userMetricsMap
    }

    func registerObserverForUser<T: Metric>(_ observer: MetricObserver, for metricType: T.Type, userID: UserID) {
        guard var metricsMap = self.userMetrics[userID] else {
            return
        }

        let metricTypeKey = MetricType(metricType)

        guard var (metric, observers) = metricsMap[metricTypeKey] else {
            return
        }

        observers.append(observer)

        metricsMap[metricTypeKey] = (metric, observers)
        self.userMetrics[userID] = metricsMap
    }

    func removeObserverForUser<T: Metric>(_ observer: MetricObserver, for metricType: T.Type, userID: UserID) {
        guard let metricsMap = self.userMetrics[userID] else {
            return
        }

        let metricTypeKey = MetricType(metricType)

        guard var (_, observers) = metricsMap[metricTypeKey] else {
            return
        }

        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func resetAllGameMetrics(forUsers userIDs: [UserID]) {
        for userID in userIDs {
            guard let metricsMap = self.userMetrics[userID] else {
                continue
            }

            for (_, (metric, _)) in metricsMap {
                metric.resetGame()
            }
        }
    }
}
