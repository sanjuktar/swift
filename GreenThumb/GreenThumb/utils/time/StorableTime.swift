//
//  StorableTime.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

struct StorableTime: Storable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case type = "type"
        case time = "time"
    }
    
    var version: String = Defaults.version
    var type: TimeType
    var time: Time
    var name: String {
        return time.name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typ = try container.decode(TimeType.self, forKey: .type)
        type = typ
        switch typ {
        case .anytimeEver:
            time = try container.decode(AnyTimeEver.self, forKey: .time)
        case .anytimeOfDay:
            time = try container.decode(AnyTimeOfDay.self, forKey: .time)
        case .anytimeOfYear:
            time = try container.decode(AnyTimeOfYear.self, forKey: .time)
        case .date:
            time = try container.decode(Date.self, forKey: .time)
        case .timeOfDay:
            time = try container.decode(TimeOfDay.self, forKey: .time)
        case .timeOfYear:
            time = try container.decode(TimeOfYear.self, forKey: .time)
        case .timeWindow:
            time = try container.decode(TimeWindow.self, forKey: .time)
        }
    }
    
    init(_ time: Time) throws {
        switch time {
        case is AnyTimeEver:
            type = .anytimeEver
        case is AnyTimeOfDay:
            type = .anytimeOfDay
        case is AnyTimeOfYear:
            type = .anytimeOfYear
        case is Date:
            type = .date
        case is TimeOfDay:
            type = .timeOfDay
        case is TimeOfYear:
            type = .timeOfYear
        case is TimeWindow:
            type = .timeWindow
        default:
            throw GenericError("Type unknown for time \(time)")
        }
        self.time = time
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(type, forKey: .type)
        switch type {
        case .anytimeEver:
            try container.encode((time as! AnyTimeEver), forKey: .time)
        case .anytimeOfDay:
            try container.encode((time as! AnyTimeOfDay), forKey: .time)
        case .anytimeOfYear:
            try container.encode((time as! AnyTimeOfYear), forKey: .time)
        case .date:
            try container.encode((time as! Date), forKey: .time)
        case .timeOfDay:
            try container.encode((time as! TimeOfDay), forKey: .time)
        case .timeOfYear:
            try container.encode((time as! TimeOfYear), forKey: .time)
        case .timeWindow:
            try container.encode((time as! TimeWindow), forKey: .time)
        }
    }
}
