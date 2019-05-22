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
        static var defaultName: String = "Season.Manager"
        
        static func load(name: String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Manager.self))!
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
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(name, "Season")
        }
    }
}
