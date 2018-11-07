//
//  TimeUnit.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 9/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Int {
    var seconds: TimeInterval {
        return 1
    }
    var minutes: TimeInterval {
        return 60.seconds
    }
    var hours: TimeInterval {
        return 60.minutes
    }
    var days: TimeInterval {
        return 24.hours
    }
    var weeks: TimeInterval {
        return 7.days
    }
    var months: TimeInterval {
        return 12.months
    }
}

extension Double {
    var durationString: String {
        let (allMinutes,seconds) = Int(self).quotientAndRemainder(dividingBy: 60)
        let (hours, minutes) = allMinutes.quotientAndRemainder(dividingBy: 60)
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return String("\(formatter.string(from: self))")
    }
}

enum TimeUnit : String, MeasurementUnit {
    case seconds = "seconds"
    case minutes = "minutes"
    case hours = "hours"
    case days = "days"
    case weeks = "weeks"
    case months = "months"
    
    static var cases: [MeasurementUnit] = [TimeUnit.seconds, TimeUnit.minutes, TimeUnit.hours, TimeUnit.days, TimeUnit.weeks, TimeUnit.months]
    static var defaut: MeasurementUnit = TimeUnit.minutes
    var name: String {
        return rawValue
    }
    var singleName: String {
        var name = rawValue
        name.removeLast()
        return name
    }
    var index: Int {
        for i in 0..<TimeUnit.cases.count {
            if (TimeUnit.cases[i] as! TimeUnit) == self {
                return i
            }
        }
        return -1
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
            throw UnableToDetermineUnitError("time", (TimeUnit.defaut as! TimeUnit).rawValue)
        }
    }
    
    func string(_ val: Double) -> String {
        let interval: TimeInterval = val
        return String(format:"%.2f ", interval) + (val == 1.0 ? singleName : name)
    }
}
