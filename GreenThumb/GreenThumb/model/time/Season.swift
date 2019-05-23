//
//  Season.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/21/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class AllYear: Season {
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    init() {
        super.init("all year", TimeOfYear.start, TimeOfYear.end)
    }
}

class RestOfTheYear: Season {
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    init() {
        super.init("rest of the year", TimeOfYear.start, TimeOfYear.end)
    }
}

class Season: TimeWindow, IdedObj {
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case name
        case start
        case end
    }
    
    static var manager: Manager? 
    static var allYear = AllYear()
    static var restOfYear = RestOfTheYear()
    var version: String
    var id: UniqueId
    var name: String?
    var desc: String {
        return description
    }
    
    var dateInterval: DateInterval {
        return DateInterval(start: start.value, end: end.value)
    }
    
    static func current(in seasons: [Season]) -> Season {
        guard !(Season.manager?.objs.isEmpty)! else {return Season.allYear}
        let today = Date()
        for season in seasons {
            if season.contains(today) {
                return season
            }
        }
        return Season.restOfYear
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let t1 = try container.decode(TimeOfYear.self, forKey: .start)
        let t2 = try container.decode(TimeOfYear.self, forKey: .end)
        super.init(start: t1, end: t2)
    }
    
    init(_ name: String, _ start: TimeOfYear, _ end: TimeOfYear) {
        version = Season.defaultVersion
        id = (Season.manager?.newId())!
        super.init(start: start, end: end)
        self.name = name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode((start as! TimeOfYear), forKey: .start)
        try container.encode((end as! TimeOfYear), forKey: .end)
    }
    
    func persist() throws {
        try Season.manager?.add(self)
    }
    
    func unpersist() throws {
        try Season.manager?.remove(self)
    }
    
    func contains(_ date: Date) -> Bool {
        return dateInterval.contains(date)
    }
}

