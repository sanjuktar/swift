//
//  MeasurementUnits.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class MeasurementUnits: CodableObj {
    typealias UnitList = [MeasurementType:MeasurementUnit]
    
    static var current: MeasurementUnits = (Settings.current?.units)!
    var name: String
    var distance: DistanceUnit
    var pace: SpeedUnit
    var duration: TimeUnit
    var altitude: DistanceUnit
    var id: String {
        return createId(with: name)
    }
    
    static func metric(shortTrip: Bool = false) -> MeasurementUnits {
        if shortTrip {
            return MeasurementUnits("metricShortTrip",
                                    distance: DistanceUnit.meters,
                                    pace: SpeedUnit.kmPerHr,
                                    duration: TimeUnit.seconds,
                                    altitude: DistanceUnit.meters)
        }
        return MeasurementUnits("metric",
                                distance: DistanceUnit.km,
                                pace: SpeedUnit.kmPerHr,
                                duration: TimeUnit.seconds,
                                altitude: DistanceUnit.meters)
    }
    
    static func imperial(shortTrip: Bool = false) -> MeasurementUnits {
        if shortTrip {
            return MeasurementUnits("inperialShortTrip",
                                    distance: DistanceUnit.yards,
                                    pace: SpeedUnit.milesPerHr,
                                    duration: TimeUnit.seconds,
                                    altitude: DistanceUnit.feet)
        }
        return MeasurementUnits("imperial",
                                distance: DistanceUnit.miles,
                                pace: SpeedUnit.milesPerHr,
                                duration: TimeUnit.seconds,
                                altitude: DistanceUnit.feet)
    }
    
    init(_ name: String = "", distance: DistanceUnit, pace: SpeedUnit, duration: TimeUnit, altitude: DistanceUnit) {
        self.name = name
        self.distance = distance
        self.pace = pace
        self.duration = duration
        self.altitude = altitude
    }
}
