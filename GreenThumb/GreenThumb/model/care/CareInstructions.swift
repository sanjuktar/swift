//
//  CareInstructions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

typealias CareSchedule = [CareType:SeasonalSchedule]

class CareInstructions: Storable {
    enum CodingKeys: String, CodingKey {
        case version
        case name
        case schedule
        case notes
    }
    var version: String
    var name: String
    var schedule: CareSchedule
    var notes: String
    var description: String {
        return name
    }
    var isValid: Bool {
        return CareDetail.validate(self)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        name = try container.decode(String.self, forKey: .name)
        do {
            schedule = try container.decode([CareType:SeasonalSchedule].self, forKey: .schedule)
        } catch {
            schedule = [:]
            AppDelegate.current?.log?.out(.error, "Unable to load plant care schedule.: \(error)")
        }
        notes = try container.decode(String.self, forKey: .notes)
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        self.name = name
        schedule = [:]
        schedule = Defaults.care!
        notes = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(notes, forKey: .notes)
    }
    
    func currentSeason(_ detail: CareType) -> Season {
        if !schedule.keys.contains(detail) {
            return Season.manager!.get(AllYear.id)!
        }
        return Season.Manager.find(Date(), in: schedule[detail]!.seasons)
    }
    
    func current(_ detail: CareType) -> Timetable {
        return (schedule[detail]?.current)!
    }
}
