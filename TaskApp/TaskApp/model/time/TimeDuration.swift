//
//  TimeDuration.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 8/11/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class TimeDuration : Time {
    var timeinterval: TimeInterval
    var label: String
    var date: Date {
        return Date.referenceDate.addingTimeInterval(timeinterval)
    }
    
    init(_ time: TimeInterval, _ label: String = "") {
        self.timeinterval = time
        self.label = label
    }
    
    convenience init(_ time: TimeOfDay, _ label: String = "") {
        self.init(time.nSeconds, label)
    }
    
    convenience init(_ time: Date, _ label: String = "") {
        self.init(time.timeIntervalSince(Date.referenceDate), label)
    }
    
    convenience init(_ time: TimeWindow, _ label: String = "") {
        self.init(time.duration, label)
    }
    
    func equals(_ time: Time) -> Bool {
        if time is AmountOfTime {
            return (time as! AmountOfTime).timeinterval == timeinterval
        }
        if time is TimeOfDay {
            return (time as! TimeOfDay).nSeconds == timeinterval
        }
        if time is Date {
            return (time as! Date).timeIntervalSince(Date.referenceDate) == timeinterval
        }
        return false
    }
    
    func plus(_ time: Time) -> Time? {
        if time is AmountOfTime {
            return AmountOfTime(timeinterval + (time as! AmountOfTime).timeinterval)
        }
        if time is TimeOfDay {
            return (time as! TimeOfDay).plus(self)
        }
        if time is Date {
            return (time as! Date).add(self)
        }
        if time is TimeWindow {
            return (time as! TimeWindow).add(self)
        }
        return nil
    }
    
    func minus(_ time: Time) -> Time? {
        if time is AmountOfTime {
            return AmountOfTime(min(timeinterval + (time as! AmountOfTime).timeinterval, 0))
        }
        if time is TimeOfDay {
            return (time as! TimeOfDay).minus(self)
        }
        if time is Date {
            return (time as! Date).minus(self)
        }
        if time is TimeWindow {
            return (time as! TimeWindow).minus(self)
        }
        return nil
    }
}
