//
//  TimeOfYear.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class TimeOfYear: Time, Codable {
    static var start = TimeOfYear(name: "start of year", 1, 1)
    static var end = TimeOfYear(name: "end of year", 31, 12)
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var name: String = ""
    var date: Int
    var month: Int
    var value: Date {
        return DateComponents(calendar: Calendar.current, year: 1970, month: month, day: date).date!
    }
    var description: String {
        return name.isEmpty ? TimeOfYear.formatter.string(from: value) : name
    }
    
    init(_ date: Date) {
        self.date = date.date
        month = date.month
    }
    
    init(name: String = "", _ date: Int, _ month: Int) {
        self.date = date
        self.month = month-1
    }
}
