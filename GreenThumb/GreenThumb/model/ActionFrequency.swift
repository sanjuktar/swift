//
//  ActionFrequency.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class ActionFrequency: Codable {
    /*enum CodingKeys: String, CodingKey {
        case nTimes
        case interval
        case lastTime
    }*/
    
    var nTimes: Int
    var interval: TimeDuration
    var lastTime: Date
    var desc: String {
        return "\(nTimes)x every \(interval)"
    }
    
    /*required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nTimes = try container.decode(Int.self, forKey: .nTimes)
        interval = try container.decode(Double.self, forKey: .interval)
        lastTime = try container.decode(Date.self, forKey: .lastTime)
    }*/
    
    init(nTimes: Int = 1, interval: TimeDuration = 1.years, lastTime: Date = Date()) {
        self.nTimes = nTimes
        self.interval = interval
        self.lastTime = lastTime
    }
    
    /*func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nTimes, forKey: .nTimes)
        try container.encode(lastTime, forKey: .lastTime)
    }*/
    
    func nextTime() -> Date {
        return nextTime(from: lastTime)
    }
    
    func nextTime(from: Date) -> Date {
        return from + Double(interval)/Double(nTimes)
    }
}
