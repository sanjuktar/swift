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
    var timetable: [UniqueId:Timetable]
    var seasons: [UniqueId] {
        return timetable.keys.map{$0}
    }
    var current: Timetable? {
        return timetable[Season.Manager.find(Date(), in: seasons).id]
    }
    
    init() {
        version = Defaults.version
        timetable = [UniqueId:Timetable]()
        for season in Defaults.seasonal.seasonsList {
            for care in CareType.allCases {
                if let action = Defaults.care[care] {
                    timetable[season] = Timetable(action!.id, Defaults.frequency[care]!)
                }
            }
        }
    }
}
