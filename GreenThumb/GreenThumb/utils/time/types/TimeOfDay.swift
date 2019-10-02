//
//  TimeOfDay.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class TimeOfDay :Time {
    static let formatter = TimeOfDay.getFormatter()
    static let start = TimeOfDay(name: "midnight", 0.seconds)
    static let end = TimeOfDay(name: "end of day", 23.hours+59.minutes+59.seconds)
    static let noon = TimeOfDay(name: "noon", 12.hours)
    var name: String = ""
    var nSeconds :TimeInterval = noon.nSeconds
    var description: String {
        return name.isEmpty ? TimeOfDay.formatter.string(from: DateComponents(second: Int(nSeconds)))! : name
    }
    var value :Date {
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
    
    init(name: String = "", _ timeinterval :TimeInterval) {
        nSeconds = timeinterval
    }
    
    init(name: String = "", _ time :Time) {
        self.name = name
        if let date = time as? Date {
            self.nSeconds = TimeInterval(Int(date.timeIntervalSince1970) % Int(1.days))
        }
        else if let timeofday = time as? TimeOfDay {
            nSeconds = timeofday.nSeconds
        }
    }
}
