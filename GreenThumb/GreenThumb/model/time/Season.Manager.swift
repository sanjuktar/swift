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
        enum SeasonKeys: String, CodingKey {
            case allYear = "all year"
            case restOfTheYear = "rest of the year"
        }
        
        static var defaultName: String = "Season.Manager"
        
        static func load(name: String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Manager.self))!
        }
        
        static func find(_ date: Date, in seasons: [UniqueId]) -> Season {
            if seasons.isEmpty || (seasons.count == 1 && seasons[0] == AllYear.id) {
                return Season.manager!.objs[AllYear.id]!
            }
            for id in seasons {
                if let season = Season.manager!.objs[id] {
                    if season.contains(date) {
                        return season
                    }
                }
            }
            return (Season.manager!.objs[RestOfTheYear.id])!
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
         /*   do {
                try super.init(from: decoder)
                let container = try decoder.container(keyedBy: SeasonKeys.self)
                do {
                    AllYear.id = try container.decode(UniqueId.self, forKey: .allYear)
                } catch {
                    throw GenericError("Unable to load season(\(AllYear.defaultName)): \(error)")
                }
                do {
                    Season.restOfYear = try container.decode(UniqueId.self, forKey: .restOfTheYear)
                } catch {
                    throw GenericError("Unable to load season(\(RestOfTheYear.defaultName)): \(error)")
                }
            } catch {
                throw GenericError("Unable to load seasons list: \(error)")
            }
        }*/
        
        init(_ name: String = Manager.defaultName) {
            super.init(name, "Season")
        }
        
        /*override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: SeasonKeys.self)
            try container.encode(Season.allYear, forKey: .allYear)
            try container.encode(Season.restOfYear, forKey: .restOfTheYear)
        }*/
    }
}
