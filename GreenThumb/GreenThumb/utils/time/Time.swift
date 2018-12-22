//
//  Time.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

typealias TimeDuration = TimeInterval

protocol Time : CustomStringConvertible{
    var value :Date {get}
}

extension Time {
    func equals(_ rhs :Time) -> Bool {
        return description == rhs.description
    }
}

extension Int {
    var seconds: TimeInterval {
        return Double(self)*1
    }
    var minutes: TimeInterval {
        return Double(self)*60.seconds
    }
    var hours: TimeInterval {
        return Double(self)*60.minutes
    }
    var days: TimeInterval {
        return Double(self)*24.hours
    }
    var weeks: TimeInterval {
        return Double(self)*7.days
    }
    var months: TimeInterval {
        return Double(self)*30.days
    }
    var years: TimeInterval {
        return Double(self)*12.months
    }
}

