//
//  ActionFrequency.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class ActionFrequency: Storable, CustomStringConvertible, Equatable {
    static var never = ActionFrequency("never", nTimes: 0, timeUnitX: 0)
    static var once = ActionFrequency("once", nTimes: 1, timeUnitX: 0)
    static var hourly = ActionFrequency("hourly", nTimes: 1, timeUnit: .hours)
    static var daily = ActionFrequency("daily", nTimes: 1, timeUnit: .days)
    static var weekly = ActionFrequency("weekly", nTimes: 1, timeUnit: .weeks)
    static var monthly = ActionFrequency("monthly", nTimes: 1, timeUnit: .months)
    static var yearly = ActionFrequency("yearly", nTimes: 1, timeUnit: .years)
    
    var version: String
    var name: String = ""
    var nTimes: Int
    var timeUnitX: Int
    var timeUnit: TimeUnit
    var window: TimeWindow?
    var description: String {
        if self == ActionFrequency.never {
            return "never"
        }
        if onlyOnce {
            if window != nil {
                return "once"
            }
            return "once on \(window!.start)"
        }
        let when = window != nil ? window?.description : AnyTimeEver.obj.description
        return "\(nTimes)x every \(timeUnitX) \(timeUnit.string(Double(timeUnitX))) (\(when))"
    }
    var onlyOnce: Bool {
        return self == ActionFrequency.once
    }
    
    static func == (lhs: ActionFrequency, rhs: ActionFrequency) -> Bool {
        return lhs.version == rhs.version &&
               lhs.nTimes == rhs.nTimes &&
               lhs.timeUnit == rhs.timeUnit &&
               lhs.timeUnitX == rhs.timeUnitX &&
               //lhs.interval == rhs.interval &&
               lhs.window == rhs.window
    }
    
    init(_ name: String = "", nTimes: Int,
         timeUnitX: Int = 1, timeUnit: TimeUnit = TimeUnit.defaut,
         window: TimeWindow? = Always.obj) {
        version = Defaults.version
        self.name = name
        self.nTimes = nTimes
        self.timeUnitX = timeUnitX
        self.timeUnit = timeUnit
        self.window = window
    }
    
    func times(_ n: Int) -> ActionFrequency {
        var times = timeUnitX
        if timeUnitX % n == 0 {
            times /= n
        }
        return ActionFrequency(nTimes: n*nTimes, timeUnitX: times, timeUnit: timeUnit, window: window)
    }
    
    func once(_ name: String = "", on when: Date, inWindow: TimeWindow? = nil) -> ActionFrequency {
        return ActionFrequency(name,
                               nTimes: 1,
                               window: inWindow)
    }
}
