//
//  SeasonsManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Season: TimeWindow {
    init(_ start: Date, _ end: Date) {
        super.init(start: start.startOfDay, end: end.endOfDay)
    }
    
    init(_ start: TimeOfYear, end: TimeOfYear) {
        super.init(start: start, end: end)
    }
    
    func contains(_ date: TimeOfYear) -> Bool {
        
    }
}

class SeasonsManager {
    static var current = SeasonManager()
    static var allYear = Season(TimeOfYear(1, 1), TimeOfYear(31, 12))
    static var restOfYear = Season(TimeOfYear(1,1), TimeOfYear(31, 12))
    var seasons: [String:Season] = [:]
    
    func add(_ name: String, _ season: Season) {
       seasons[season.name] = season
    }
    
    func remove(_ season: String) {
        seasons.remove(at: seasons.index(forKey: season))
    }
    
    func current(in seasons: [Season]) -> Season {
        let today = Date.timeOfYear
        for season in seasons {
            if season.contains(today) {
                return season
            }
        }
        return SeasonManager
    }
}
