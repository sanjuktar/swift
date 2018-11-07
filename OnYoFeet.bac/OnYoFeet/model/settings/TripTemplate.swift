//
//  TripTemplate.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class TripTemplate: CodableObj {
    static var current = Settings.current?.tripTemplate
    static var ignore = Double.greatestFiniteMagnitude
    static var defaultPaceTolerance = 0.1.milesPerHr
    var name: String
    var pace: Double
    var duration: TimeInterval
    var distance: Double
    var paceTolerance: Double
    var durationTolerance: TimeInterval = 1.minutes
    var distanceTolerance: Double = 50.meters
    var id: String {
        return createId(with: name)
    }
    
    init(_ name: String, slowPace slow: Double, fastPace fast: Double, duration: Double = ignore, distance: Double = ignore) {
        self.name = name
        self.pace = (slow + fast)/2.0
        self.paceTolerance = fast - pace
        self.duration = duration
        self.distance = distance
    }
    
    init(_ name: String, pace: Double = ignore, tolerance: Double = defaultPaceTolerance, duration: Double = ignore, distance: Double = ignore) {
        self.name = name
        self.pace = pace
        self.paceTolerance = tolerance
        self.duration = duration
        self.distance = distance
    }
}

