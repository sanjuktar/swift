//
//  SeasonalSchedule.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

class SeasonalSchedule: Storable {
    var version: String
    var timetable: [Season:Timetable]
    var seasons: [Season] {
        return timetable.keys.map{$0}
    }
    var current: Timetable? {
        return timetable[Season.Manager.find(Date(), in: seasons)]
    }
    
    init() {
        version = SeasonalSchedule.defaultVersion
        timetable = [Season:Timetable]()
    }
}
