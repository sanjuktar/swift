//
//  CareInstructions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class CareInstructions: IdedObj {
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case name
        case schedule
        case notes
    }
    static var manager: Manager? 
    var version: String
    var id: UniqueId
    var name: String
    var schedule: [CareType:SeasonalSchedule]
    var notes: String
    var description: String {
        return name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        schedule = try container.decode([CareType:SeasonalSchedule].self, forKey: .schedule)
        notes = try container.decode(String.self, forKey: .notes)
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        id = (CareInstructions.manager?.newId())!
        self.name = name
        schedule = [:]
        for care in CareType.seasonal {
            schedule[care] = SeasonalSchedule()
        }
        notes = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(notes, forKey: .notes)
    }
    
    func currentSeason(_ detail: CareType) -> Season {
        if !schedule.keys.contains(detail) {
            return Season.manager!.get(Season.allYear!)!
        }
        return Season.Manager.find(Date(), in: schedule[detail]!.seasons)
    }
    
    func persist() throws {
        try Documents.instance?.store(self, as: id)
        try CareInstructions.manager?.add(self)
    }
    
    func unpersist() throws {
        try Documents.instance?.remove(id)
        try CareInstructions.manager?.remove(self)
    }
}
