//
//  TimeUnit.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum TimeUnit : String {
    case seconds = "seconds"
    case minutes = "minutes"
    case hours = "hours"
    case days = "days"
    case weeks = "weeks"
    case months = "months"
    
    static var cases: [TimeUnit] = [seconds, minutes, hours, days, weeks, months]
    static var defaut: TimeUnit = TimeUnit.days
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
            if TimeUnit.cases[i] == self {
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
            throw GenericError("Unable to initialize time unit of \(unit) seconds")
        }
    }
    
    func string(_ val: Double) -> String {
        let interval: TimeInterval = val
        return String(format:"%.2f ", interval) + (val == 1.0 ? singleName : name)
    }
}
