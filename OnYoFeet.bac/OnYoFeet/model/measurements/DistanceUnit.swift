//
//  DistanceUnit.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Double {
    var cm: Double {
        return 1
    }
    var inches: Double {
        return 2.54.cm
    }
    var feet: Double {
        return 30.inches
    }
    var yards: Double {
        return 3.feet
    }
    var meters: Double {
        return 100.cm
    }
    var km: Double {
        return 1000.meters
    }
    var miles: Double {
        return 5280.feet
    }
}

enum DistanceUnit : String, MeasurementUnit {
    case cm = "cm"
    case inches = "inches"
    case feet = "feet"
    case yards = "yards"
    case meters = "m"
    case km = "km"
    case miles = "miles"
    
    static var cases: [MeasurementUnit] = [DistanceUnit.cm, DistanceUnit.inches, DistanceUnit.feet, DistanceUnit.yards, DistanceUnit.meters, DistanceUnit.km, DistanceUnit.miles]
    static var defaut: MeasurementUnit = DistanceUnit.meters
    var name: String {
        return rawValue
    }
    var singleName: String {
        switch self {
        case .inches: return "inch"
        case .feet: return "foot"
        case .yards: return "yard"
        case .miles: return "mile"
        default: return rawValue
        }
    }
    var index: Int {
        for i in 0..<DistanceUnit.cases.count {
            if (DistanceUnit.cases[i] as! DistanceUnit) == self {
                return i
            }
        }
        return -1
    }
    
    init(_ unit: Double) throws {
        switch unit {
        case 1.cm: self = .cm
        case 1.inches: self = .inches
        case 1.feet: self = .feet
        case 1.yards: self = .yards
        case 1.meters: self = .meters
        case 1.km: self = .km
        case 1.miles: self = .miles
        default:
            throw UnableToDetermineUnitError("distance", (DistanceUnit.defaut as! DistanceUnit).rawValue)
        }
    }
    
    func string(_ distance: Double) -> String {
        return String(format:"%.2f ", distance) + (distance == 1.0 ? singleName : name)
    }
}

