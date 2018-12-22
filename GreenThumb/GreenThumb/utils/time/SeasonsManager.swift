//
//  SeasonsManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class Season: TimeWindow {
    var dateInterval: DateInterval {
        return DateInterval(start: start.value, end: end.value)
    }
    
    init(start: Date, end: Date) {
        super.init(start: start.startOfDay, end: end.endOfDay)
    }
    
    init(_ start: TimeOfYear, _ end: TimeOfYear) {
        super.init(start: start, end: end)
    }
    
    /*func contains(_ date: TimeOfYear) -> Bool {
        return dateInterval.contains(date.value)
    }*/
    
    func contains(_ date: Date) -> Bool {
        return dateInterval.contains(date)
    }
}

class SeasonsManager {
    static var instance = SeasonsManager()
    static var allYear = Season(TimeOfYear.start, TimeOfYear.end)
    static var restOfYear = Season(TimeOfYear.start, TimeOfYear.end)
    var seasons: [String:Season] = [:]
    
    static func add(_ name: String, _ season: Season) {
        instance.seasons[name] = season
    }
    
    static func remove(_ season: String) {
        instance.seasons.remove(at: instance.seasons.index(forKey: season)!)
    }
    
    static func current(in seasons: [Season]) -> Season {
        guard !instance.seasons.isEmpty else {return SeasonsManager.allYear}
        let today = Date()
        for season in seasons {
            if season.contains(today) {
                return season
            }
        }
        return SeasonsManager.restOfYear
    }
}
