//
//  SeasonalSchedule.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class SeasonalSchedule: Storable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case name = "name"
        case timetable = "timetable"
    }
    
    var version: String
    var name: String
    var timetable: [UniqueId:Timetable]
    var description: String {
        return name
    }
    var seasons: [UniqueId] {
        return timetable.keys.map{$0}
    }
    var current: Timetable? {
        return timetable[Season.Manager.find(Date(), in: seasons).id]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        name = try container.decode(String.self, forKey: .name)
        timetable = try container.decode([UniqueId:Timetable].self, forKey: .timetable)
    }
    
    init(_ name: String = "", care: CareType, timetable: [UniqueId:Timetable]? = nil) {
        version = Defaults.version
        self.name = name
        self.timetable = timetable != nil ? timetable! : Defaults.care![care]!.timetable
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
        try container.encode(timetable, forKey: .timetable)
    }
}
