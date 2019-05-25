//
//  Date.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Date :Time {
    static var formatter = Date.getFormatter()
    var description :String {
        return Date.formatter.string(from :self)
    }
    var value :Date {
        return self
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return DateComponents(calendar: Calendar.current, year: components.year, month: components.month, day: components.day, hour: 23, minute: 59, second: 59).date!
    }
    var today: Date {
        return Date().endOfDay
    }
    var tomorrow: Date {
        return today.addingTimeInterval(1.days)
    }
    var date: Int {
        return Calendar.current.dateComponents([.day], from: self).day!
    }
    var month: Int {
        return Calendar.current.dateComponents([.month], from: self).day!
    }
    
    static func getFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
}
