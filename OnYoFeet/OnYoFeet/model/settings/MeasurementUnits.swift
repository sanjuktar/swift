//
//  MeasurementUnits.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class MeasurementUnits {
    typealias UnitList = [MeasurementType:MeasurementUnit]
    
    static var current: MeasurementUnits = (Settings.current?.units)!    
    var distance: DistanceUnit
    var pace: SpeedUnit
    var duration: TimeUnit
    var altitude: DistanceUnit
    
    static func metric(shortTrip: Bool = false) -> MeasurementUnits {
        if shortTrip {
            return MeasurementUnits(distance: DistanceUnit.meters,
                                    pace: SpeedUnit.kmPerHr,
                                    duration: TimeUnit.seconds,
                                    altitude: DistanceUnit.meters)
        }
        return MeasurementUnits(distance: DistanceUnit.km,
                                pace: SpeedUnit.kmPerHr,
                                duration: TimeUnit.seconds,
                                altitude: DistanceUnit.meters)
    }
    
    static func imperial(shortTrip: Bool = false) -> MeasurementUnits {
        if shortTrip {
            return MeasurementUnits(distance: DistanceUnit.yards,
                                    pace: SpeedUnit.milesPerHr,
                                    duration: TimeUnit.seconds,
                                    altitude: DistanceUnit.feet)
        }
        return MeasurementUnits(distance: DistanceUnit.miles,
                                pace: SpeedUnit.milesPerHr,
                                duration: TimeUnit.seconds,
                                altitude: DistanceUnit.feet)
    }
    
    init(distance: DistanceUnit, pace: SpeedUnit, duration: TimeUnit, altitude: DistanceUnit) {
        self.distance = distance
        self.pace = pace
        self.duration = duration
        self.altitude = altitude
    }
}
