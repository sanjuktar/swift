//
//  SpeedUnit.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Double {
    var metersPerSec: Double {
        return 1
    }
    var yardsPerSec: Double {
        return 1.meters/1.yards
    }
    var kmPerHr: Double {
        return 1.km/1.hours
    }
    var milesPerHr: Double {
        return 1.miles/1.hours
    }
}

enum SpeedUnit : String, MeasurementUnit {
    case mPerS = "m/s"
    case yardsPerS = "yards/s"
    case kmPerHr = "km/h"
    case milesPerHr = "miles/h"
    
    static var cases: [MeasurementUnit] = [SpeedUnit.mPerS, SpeedUnit.yardsPerS, SpeedUnit.kmPerHr, SpeedUnit.milesPerHr]
    static var defaut: MeasurementUnit = SpeedUnit.mPerS
    var name: String {
        return rawValue
    }
    var singleName: String {
        return rawValue
    }
    var index: Int {
        for i in 0..<SpeedUnit.cases.count {
            if (SpeedUnit.cases[i] as! SpeedUnit) == self {
                return i
            }
        }
        return -1
    }
    
    init(_ unit: Double) throws {
        switch unit {
        case 1.0.metersPerSec: self = .mPerS
        case 1.0.yardsPerSec: self = .yardsPerS
        case 1.0.kmPerHr: self = .kmPerHr
        case 1.0.milesPerHr: self = .milesPerHr
        default:
            throw UnableToDetermineUnitError("speed", (SpeedUnit.defaut as! SpeedUnit).rawValue)
        }
    }
    
    func string(_ val: Double) -> String {
        let pace = MeasurementUnits.current.pace
        return String(format: "%.2f ", val) + (val == 1 ? pace.singleName : pace.name)
    }
}

