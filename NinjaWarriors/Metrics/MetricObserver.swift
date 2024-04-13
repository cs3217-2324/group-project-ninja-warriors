//
//  MetricObserver.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 13/4/24.
//

import Foundation

protocol MetricObserver: AnyObject {
    func notify(_ metric: Metric)
}
