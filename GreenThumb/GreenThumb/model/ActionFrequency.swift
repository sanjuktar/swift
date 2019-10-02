//
//  ActionFrequency.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class ActionFrequency: Storable, CustomStringConvertible, Equatable {
    static var never = ActionFrequency("never", nTimes: 0, interval: 0)
    static var once = ActionFrequency("once", nTimes: 1, interval: 0)
    static var hourly = ActionFrequency("hourly", nTimes: 1, interval: 1.hours)
    static var daily = ActionFrequency("daily", nTimes: 1, interval: 1.days)
    static var weekly = ActionFrequency("weekly", nTimes: 1, interval: 1.weeks)
    static var monthly = ActionFrequency("monthly", nTimes: 1, interval: 1.months)
    static var yearly = ActionFrequency("yearly", nTimes: 1, interval: 1.years)
    
    var version: String
    var name: String = ""
    var nTimes: Int
    var interval: TimeDuration
    var nextTime: Date
    var window: TimeWindow
    var description: String {
        if self == ActionFrequency.never {
            return "never"
        }
        if onlyOnce {
            return "once on \(window.start)"
        }
        return "\(nTimes)x every \(interval.inUnits) (\(window))"
    }
    var onlyOnce: Bool {
        return nTimes == 1 && interval == TimeInterval.greatestFiniteMagnitude
    }
    
    static func == (lhs: ActionFrequency, rhs: ActionFrequency) -> Bool {
        return lhs.version == rhs.version &&
               lhs.nTimes == rhs.nTimes &&
               lhs.interval == rhs.interval &&
               lhs.window == rhs.window
    }
    
    init(_ name: String = "", nTimes: Int,
         interval: TimeDuration, nextTime: Date = Date()+1.days,
         window: TimeWindow = Always.obj) {
        version = Defaults.version
        self.name = name
        self.nTimes = nTimes
        self.interval = interval
        self.nextTime = nextTime
        self.window = window
    }
    
    func times(_ n: Int) -> ActionFrequency {
        return ActionFrequency(nTimes: n*nTimes, interval: interval, window: window)
    }
    
    func once(_ name: String = "", on when: Date, inWindow: TimeWindow = Always.obj) -> ActionFrequency {
        return ActionFrequency(name,
                               nTimes: 1,
                               interval: TimeInterval.greatestFiniteMagnitude,
                               nextTime: when)
    }
}
