//
//  ActionFrequency.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class ActionFrequency: Storable, CustomStringConvertible {
    static var once = ActionFrequency(nTimes: 1, interval: 1.weeks, lastTime: Date())
    static var hourly = ActionFrequency(nTimes: 1, interval: 1.hours, lastTime: Date.distantFuture)
    static var daily = ActionFrequency(nTimes: 1, interval: 1.days, lastTime: Date.distantFuture)
    static var weekly = ActionFrequency(nTimes: 1, interval: 1.weeks, lastTime: Date.distantFuture)
    static var monthly = ActionFrequency(nTimes: 1, interval: 1.months, lastTime: Date.distantFuture)
    static var yearly = ActionFrequency(nTimes: 1, interval: 1.years, lastTime: Date.distantFuture)
    
    var version: String
    var nTimes: Int
    var interval: TimeDuration
    var lastTime: Date
    var description: String {
        return "\(nTimes)x every \(interval)"
    }
    
    init(nTimes: Int /*= Defaults.frequency[.generic].nTimes*/,
         interval: TimeDuration /*= Defaults.frequency[.generic].interval*/,
         lastTime: Date /*= Defaults.frequency.[generic.lastTime*/) {
        version = Defaults.version
        self.nTimes = nTimes
        self.interval = interval
        self.lastTime = lastTime
    }
    
    func nextTime() -> Date {
        return nextTime(from: lastTime)
    }
    
    func nextTime(from: Date) -> Date {
        return from + Double(interval)/Double(nTimes)
    }
    
    func times(_ n: Int) -> ActionFrequency {
        return ActionFrequency(nTimes: n*nTimes, interval: interval, lastTime: lastTime)
    }
}
