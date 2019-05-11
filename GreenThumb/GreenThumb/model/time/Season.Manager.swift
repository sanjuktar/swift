//
//  Season.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

//typealias ConditionRelevantSeasons = [Condition:[Season]]

extension Season {
    class Manager: IdedObjManager<Season> {
        enum CodingKeys: String, CodingKey {
            case name
            case seasons
            case idGenerator
        }
        
        static var defaultName = "Season.Manager"
        var seasons: [Season] = []
        var log: Log? {
            return AppDelegate.current?.log
        }
        
        static func load(name: String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Season.Manager.self))!
        }
        
        static func find(_ date: Date, in seasons: [Season]) -> Season {
            for season in seasons {
                if season.contains(date) {
                    return season
                }
            }
            return Season.allYear
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
            let idList = try container.decode([UniqueId].self, forKey: .seasons)
            seasons = try idList.compactMap{try Documents.instance?.retrieve($0, as: Season.self)}
        }
        
        init(_ name: String = Manager.defaultName, _ seasons: [Season] = []) {
            super.init(name, "Season")
            self.seasons = seasons
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(seasons, forKey: .seasons)
            try container.encode(idGenerator, forKey: .idGenerator)
        }
        
        override func commit() throws {
            try Documents.instance?.store(self, as: name)
        }
        
        override func add(_ season: Season) throws {
            if seasons.firstIndex(of: season) == nil {
                seasons.append(season)
            }
            try Documents.instance?.store(season, as: season.id)
            try commit()
        }
        
        override func remove(_ season: Season) throws {
            if let pos = seasons.firstIndex(of: season) {
                seasons.remove(at: pos)
            }
            try Documents.instance?.remove(season.id)
            try commit()
        }
    }
}
