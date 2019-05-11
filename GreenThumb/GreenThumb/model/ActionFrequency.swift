//
//  ActionFrequency.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class ActionFrequency: Codable {
    
    var nTimes: Int
    var interval: TimeDuration
    var lastTime: Date
    var desc: String {
        return "\(nTimes)x every \(interval)"
    }
    
    init(nTimes: Int = 1, interval: TimeDuration = 1.years, lastTime: Date = Date()) {
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
}
