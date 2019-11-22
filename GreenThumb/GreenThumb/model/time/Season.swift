//
//  Season.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/21/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class AllYear: Season {
    static var defaultName: String = "all year"
    private static var instance: AllYear?
    static var obj: AllYear {
        if instance == nil {
            instance = AllYear()
            instance!.id = "allYear"
            do {
                try Season.manager?.add(instance!)
            } catch {
                AppDelegate.current?.log!.out(.error, "Unable to add \(instance!) to \(Season.manager!)")
            }
        }
        return instance!
    }
    static var id: UniqueId {
        return obj.id
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    private init() {
        super.init(AllYear.defaultName, TimeOfYear.start, TimeOfYear.end)
    }
}

class RestOfTheYear: Season {
    static var defaultName: String = "rest of the year"
    private static var instance: RestOfTheYear?
    static var obj: RestOfTheYear {
        if instance == nil {
            instance = RestOfTheYear()
            instance?.id = "restOfTheYear"
            do {
                try RestOfTheYear.manager?.add(instance!)
            } catch {
                AppDelegate.current?.log?.out(.error, "Unable to add \(instance!) to \(Season.manager!)")
            }
        }
        return instance!
    }
    static var id: UniqueId {
        return obj.id
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    private init() {
        super.init(RestOfTheYear.defaultName, TimeOfYear.start, TimeOfYear.end)
    }
}

class Season: TimeWindow, IdedObj {
    enum SeasonKeys: String, CodingKey {
        case id
        case name
    }
    
    static var manager: Manager?
    var version: String = Defaults.version
    var id: UniqueId
    var desc: String {
        return description
    }
    
    var dateInterval: DateInterval {
        return DateInterval(start: start.value, end: end.value)
    }
    
    static func current(in seasons: [Season]) -> Season {
        guard !(Season.manager?.objs.isEmpty)! else {return Season.manager!.get(AllYear.id)!}
        let today = Date()
        for season in seasons {
            if season.contains(today) {
                return season
            }
        }
        return Season.manager!.get(RestOfTheYear.id)!
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SeasonKeys.self)
        id = try container.decode(UniqueId.self, forKey: .id)
        try super.init(from: decoder)
    }
    
    init(_ name: String, _ start: TimeOfYear, _ end: TimeOfYear) {
        id = (Season.manager?.newId())!
        super.init(name, start: start, end: end)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: SeasonKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    func persist() throws {
        try Season.manager?.add(self)
    }
    
    func unpersist() throws {
        try Season.manager?.remove(id)
    }
    
    func contains(_ date: Date) -> Bool {
        return dateInterval.contains(date)
    }
}

