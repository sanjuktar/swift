//
//  TimeUnit.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum TimeUnit : String, CaseIterable, CustomStringConvertible {
    case seconds = "seconds"
    case minutes = "minutes"
    case hours = "hours"
    case days = "days"
    case weeks = "weeks"
    case months = "months"
    
    static var defaut: TimeUnit = TimeUnit.days
    var description: String {
        return rawValue
    }
    var duration: TimeDuration {
        switch self {
        case .seconds:
            return 1.seconds
        case .minutes:
            return 1.minutes
        case .hours:
            return 1.hours
        case .days:
            return 1.days
        case .weeks:
            return 1.weeks
        case .months:
            return 1.months
        }
    }
    var singleName: String {
        var name = rawValue
        name.removeLast()
        return name
    }
    var index: Int {
        return TimeUnit.allCases.firstIndex(of: self)!
    }
    
    static func description(_ time: TimeDuration) -> String {
        if time == 0 {
            return "0 \(TimeUnit.seconds)"
        }
        for unit in TimeUnit.allCases {
            if unit.duration == time {
                return unit.singleName
            }
         }
        var current = Int(time)
        var units: [String] = []
        for unit in TimeUnit.allCases.reversed() {
            let n = Int(time/unit.duration)
            if n != 0 {
                units.append("\(n) \(unit)")
                current -= n*Int(unit.duration)
            }
        }
        return units.joined(separator: " ")
    }
    
    init(_ unit: Double) throws {
        switch unit {
        case 1.seconds: self = .seconds
        case 1.minutes: self = .minutes
        case 1.hours: self = .hours
        case 1.days: self = .days
        case 1.weeks: self = .weeks
        case 1.months: self = .months
        default:
            throw GenericError("Unable to initialize time unit of \(unit) seconds")
        }
    }
    
    func string(_ val: Double) -> String {
        let interval: TimeInterval = val
        return String(format:"%.2f ", interval) + (val == 1.0 ? singleName : description)
    }
}
