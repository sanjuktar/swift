//
//  TimeWindow.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Always: TimeWindow {
    private static var instance: Always?
    static var obj: Always {
        if instance == nil {
            instance = Always()
        }
        return instance!
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    private init() {
        super.init("always", start: Date.distantPast, end: Date.distantFuture)
    }
}

class TimeWindow: Time, Hashable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case name = "name"
        case start = "start"
        case end = "end"
    }
    
    var name: String = ""
    var start: Time
    var end: Time
    var description: String {
        return name.isEmpty ? "\(String(describing: start)) to \(String(describing: end))" : name
    }
    var value: Date {
        return end.value
    }
    
    static func == (lhs: TimeWindow, rhs: TimeWindow) -> Bool {
        return lhs.start.equals(rhs.start) &&
            lhs.end.equals(rhs.end)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //version = try container.decode(String.self, forKey: .version)
        name = try container.decode(String.self, forKey: .name)
        start = try container.decode(StorableTime.self, forKey: .start).time
        end = try container.decode(StorableTime.self, forKey: .end).time
    }
    
    init(_ name: String = "", start :Time, end :Time) {
        self.name = name
        self.start = start
        self.end = end
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
        try container.encode(StorableTime(start), forKey: .start)
        try container.encode(StorableTime(end), forKey: .end)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(start.description + end.description)
    }
}
