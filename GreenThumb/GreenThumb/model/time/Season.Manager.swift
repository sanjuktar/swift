//
//  Season.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

extension Season {
    class Manager: IdedObjManager<Season> {
        enum CodingKeys: String, CodingKey {
            case name
            case seasons
            case idGenerator
        }
        
        static var defaultName = "Season.Manager"
        var seasons: [String:Season] = [:]
        var log: Log? {
            return AppDelegate.current?.log
        }
        
        static func load(name: String = defaultName) throws -> Season.Manager {
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
            let idList = try container.decode([String:Season].self, forKey: .seasons)
            seasons = [:]
            for id in idList.keys {
                let season = try Documents.instance?.retrieve(id, as: Season.self)
                seasons[(season?.id)!] = season
            }
            idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
        }
        
        init(_ name: String = Manager.defaultName, _ seasons: [String:Season] = [:]) {
            super.init(name, "Season")
            self.seasons = seasons
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(Array(seasons.keys), forKey: .seasons)
            try container.encode(idGenerator, forKey: .idGenerator)
        }
        
        override func commit() throws {
            try Documents.instance?.store(self, as: name)
        }
        
        override func add(_ season: Season) throws {
            seasons[name] = season
            try commit()
        }
        
        override func remove(_ season: Season) throws {
            seasons.remove(at: (Season.manager?.seasons.index(forKey: season.id)!)!)
            try commit()
        }
    }
}
