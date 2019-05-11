//
//  Location.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

typealias ConditionsList = [Location.Conditions:Condition]
typealias AnnualConditions = [Location.Conditions:SeasonalConditions]
typealias SeasonalConditions = [Season:Condition]

class Location: IdedObj {
    enum Conditions: String, Codable {
        case inOrOut
        case light
        case rain
        case humidity
        case wind
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case conditions
        case conditionsUsed
    }
    
    static var locationUnknown = "Location Unknown"
    static var unknownLocation = Location(Location.locationUnknown)
    static var manager: Location.Manager? {
        return AppDelegate.current?.locations
    }
    static var indoorConditions: [Conditions] = [.inOrOut, .light, .humidity]
    static var outdoorConditions: [Conditions] = [.inOrOut, .light, .rain, .humidity, .wind]
    static var defaultConditions: ConditionsList = [.inOrOut:InOrOut(), .light:LightExposure(), .rain:Rain(), .humidity:Humidity(), .wind:Wind()]
    var id: UniqueId
    var name: String
    var conditions: AnnualConditions
    var conditionsUsed: [Conditions]
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        conditions = try container.decode(AnnualConditions.self, forKey: .conditions)
        conditionsUsed = try container.decode([Conditions], forKey: .conditionsUsed)
    }
    
    init(_ name: String, conditions:AnnualConditions? = nil) {
        self.id = (Location.manager?.newId())!
        self.name = name
        if conditions != nil {
            self.conditions = conditions!
        }
        else{
            let seasonalConditions: SeasonalConditions? = conditions[Conditions.inOrOut]
            let seasons = seasonalConditions?.keys.map{$0} ?? [Season.allYear]
            if (conditions[.inOrOut]![Season.Manager.find(Date(), in: seasons)] as! InOrOut).isOutdoors  {
                conditionsUsed = Location.outdoorConditions
            }
            else {
                conditionsUsed = Location.indoorConditions
            }
            var map: AnnualConditions = [:]
            Location.defaultConditions.forEach{map[$0.key] = [Season.allYear:$0.value]}
            self.conditions = map
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(conditions, forKey: .conditions)
    }
    
    func clone() -> Location {
        let obj = Location(name, conditions: conditions)
        obj.id = id
        return obj
    }
    
    func persist() throws {
        try Location.manager?.add(self)
    }
    
    func unpersist() throws {
        try Location.manager?.remove(self)
    }
    
    func condition(_ detail: Conditions) -> Condition {
        var seasons = validSeasons(detail)
        var season: Season
        if seasons == nil {
            addCondition(detail, Season.allYear, Location.defaultConditions[detail])
        }
        else {
            season = Season.Manager.find(Date(), in: seasons!)
        }
        if let retVal = conditions[detail]![season] {
            return retVal
        }
        var vals = Location.indoorConditions
        if (conditions[.inOrOut]![season] as! InOrOut).isOutdoors {
            vals = Location.outdoorConditions
        }
        return vals[detail]!
    }
    
    func addCondition(_ detail: Conditions, _ season: Season, _ value: Condition) {
        conditions[detail] = [:]
        conditions[detail]![Season.allYear] = Location.defaultConditions[detail]
    }
    
    func currentSeason(_ condition: Conditions) -> Season {
        return Season.Manager.find(Date(), in: validSeasons(condition) ?? [Season.allYear])
    }
    
    func validSeasons(_ condition: Conditions) -> [Season]? {
        return conditions[condition]?.keys.map{$0}
    }
    
    func value(_ condition: Conditions) -> Condition? {
        guard let seasons = validSeasons(condition) else {return nil}
        return conditions[condition]?[Season.Manager.find(Date(), in: seasons)] ?? nil
    }
}
