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
    var dataFromTemplate: Bool {
        switch self {
        case .targetPace:
            return true
        default:
            return false
        }
    }
    
    func data(from trip: Trip) -> String {
        switch self {
        case .name:
            return trip.name!.isEmpty ? "Unnamed" : trip.name!
        case .duration:
            return String(duration: trip.duration)
        case .start:
            return trip.start == nil ? "Not started" : String(date: trip.start!)
        case .end:
            return trip.end == nil ? "Not ended" : String(date: trip.end!)
        case .state:
            return trip.inProgress ? "In progress" : "Stopped"
        case .currentPace:
            return MeasurementUnits.current.pace.string(trip.currentPace)
        case .averagePace:
            return MeasurementUnits.current.pace.string(trip.averagePace)
        case .climb:
            return MeasurementUnits.current.distance.string(trip.climb)
        case .incline:
            return "\(trip.incline)%"
        case .distance:
            return MeasurementUnits.current.distance.string(trip.distance)
        default:
            return "Dont know"
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
