//
//  Date.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/3/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

protocol Time : CustomStringConvertible{
    var date :Date {get}
}

extension Time {
    func equals(_ rhs :Time) -> Bool {
        return description == rhs.description
    }
}

class Anytime : Time {
    var date: Date {
        return Date.distantFuture
    }
    
    var description :String {
        return "anytime"
    }
}

class AnyTimeOfDay : Time {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval.infinity)
    }
    
    var description: String {
        return "anytime"
    }
}

extension Date :Time {
    static var formatter = Date.getFormatter()
    var description :String {
        return Date.formatter.string(from :self)
    }
    var date :Date {
        return self
    }
    
    static func getFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

class TimeOfDay :Time {
    static let formatter = TimeOfDay.getFormatter()
    static let defaut :TimeInterval = 12.hours
    var nSeconds :TimeInterval = defaut
    var description: String {
        return TimeOfDay.formatter.string(from: DateComponents(second: Int(nSeconds)))!
    }
    var date :Date {
        return Date(timeIntervalSince1970: nSeconds)
    }
    
    static func == (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        return lhs.nSeconds == rhs.nSeconds
    }
    
    static func getFormatter() -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        return formatter
    }
    
    init(_ timeinterval :TimeInterval) {
        nSeconds = timeinterval
    }
    
    init(_ time :Time) {
        if let date = time as? Date {
            self.nSeconds = TimeInterval(Int(date.timeIntervalSince1970) % Int(1.days))
        }
        else if let timeofday = time as? TimeOfDay {
            nSeconds = timeofday.nSeconds
        }
    }
}

class TimeWindow :Time {
    var start :Time?
    var end :Time?
    var description: String {
        return "from \(String(describing: start)) to \(String(describing: end))"
    }
    var date :Date {
        return (end?.date)!
    }
    
    init(start :Time, end :Time) {
        self.start = start
        self.end = end
    }
}
