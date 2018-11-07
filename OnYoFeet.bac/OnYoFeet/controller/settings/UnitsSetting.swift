//
//  UnitsSetting.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum UnitsSetting : String, SettingController {
    case pace = "Pace"
    case distance = "Distance"
    case duration = "Duration"
    case altitude = "Altitude"
    
    static var cases: [UnitsSetting] = [.pace, .distance, .duration, .altitude]
    var name: String {
        return rawValue
    }
    var editType: EditType {
        switch self {
        case .pace: return .optionsTable(options: SpeedUnit.cases, selected: selected)
        case .distance, .altitude: return .optionsTable(options: DistanceUnit.cases, selected: selected)
        case .duration: return.optionsTable(options: TimeUnit.cases, selected: selected)
        }
    }
    var currentUnit: MeasurementUnit {
        get {
            let units = MeasurementUnits.current
            switch self {
            case .pace: return units.pace
            case .distance: return units.distance
            case .duration: return units.duration
            case .altitude: return units.altitude
            }
        }
        set {
            let units = MeasurementUnits.current
            switch self {
            case .pace:
                if newValue is SpeedUnit {
                    units.pace = newValue as! SpeedUnit
                }
            case .distance:
                if newValue is DistanceUnit {
                    units.distance = newValue as! DistanceUnit
                }
            case .duration:
                if newValue is TimeUnit {
                    units.duration = newValue as! TimeUnit
                }
            case .altitude:
                if newValue is DistanceUnit {
                    units.distance = newValue as! DistanceUnit
                }
            }
        }
    }
    private var selected: Int {
        return currentUnit.index
    }
    var data: String {
        return currentUnit.name
    }
}
