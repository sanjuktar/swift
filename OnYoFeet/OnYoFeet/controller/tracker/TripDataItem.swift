//
//  TripDataItem.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 8/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import CoreMotion

enum TripDataItem : String {
    case name = "Name"
    case duration = "Duration"
    case start = "Start"
    case state = "State"
    case end = "End"
    case currentPace = "Current pace"
    case averagePace = "Average pace"
    case targetPace = "Target pace"
    case incline = "Incline"
    case climb = "Climb"
    case distance = "Distance"
    
    static var cases: [TripDataItem] = [.name, .start, .duration, .currentPace, .averagePace, .distance]
    static var dataNotAvailable = "Data not available"
    var dataFromTemplate: Bool {
        switch self {
        case .targetPace:
            return true
        default:
            return false
        }
    }
    
    func data(from trip: Trip) -> String {
        let units = MeasurementUnits.current
        switch self {
        case .name:
            return trip.name!
        case .duration:
            return String(duration: trip.duration)
        case .start:
            return trip.start == nil ? "Not started" : String(date: trip.start!)
        case .end:
            return trip.end == nil ? "Not ended" : String(date: trip.end!)
        case .state:
            return trip.inProgress ? "In progress" : "Stopped"
        case .currentPace:
            if SpeedUnit.notAvailable(trip.currentPace) {
                return TripDataItem.dataNotAvailable
            }
            else {
                return units.pace.string(trip.currentPace)
            }
        case .averagePace:
            if SpeedUnit.notAvailable(trip.averagePace) {
                return TripDataItem.dataNotAvailable
            }
            else {
                return units.pace.string(trip.averagePace)
            }
        case .climb:
            if DistanceUnit.notAvailable(trip.climb) {
                return TripDataItem.dataNotAvailable
            }
            else {
                return units.altitude.string(trip.climb)
            }
        case .incline:
            if DistanceUnit.notAvailable(trip.incline) {
                return TripDataItem.dataNotAvailable
            }
            else {
                return "\(trip.incline)%"
            }
        case .distance:
            if DistanceUnit.notAvailable(trip.distance) {
                return TripDataItem.dataNotAvailable
            }
            else {
                return MeasurementUnits.current.distance.string(trip.distance)
            }
        default:
            return TripDataItem.dataNotAvailable
        }
    }
    
    func data(from template: TripTemplate) -> String {
        switch self {
        case .targetPace:
            return MeasurementUnits.current.pace.string(template.pace)
        default:
            return "Dont know"
        }
    }
}
