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
        
        var defaultValue: Condition {
            switch self {
            case .inOrOut:
                return InOrOut()
            case .light:
                return LightExposure()
            case .rain:
                return Rain()
            case .humidity:
                return Humidity()
            case .wind:
                return Wind()
            }
        }
        
        static var values: [Conditions] = [.inOrOut, .light, .rain, .humidity, .wind]
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
    static var defaultSeasons = [Season.allYear]
    var id: UniqueId
    var name: String
    var conditions: AnnualConditions
    var conditionsUsed: [Conditions]
    var isOutdoors: Bool {
        return ((value(.inOrOut) as? InOrOut) ?? InOrOut()).isOutdoors
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        conditions = try container.decode(AnnualConditions.self, forKey: .conditions)
        conditionsUsed = try container.decode([Conditions].self, forKey: .conditionsUsed)
    }
    
    init(_ name: String, conditions:AnnualConditions? = nil) {
        self.id = (Location.manager?.newId())!
        self.name = name
        if conditions != nil {
            self.conditions = conditions!
            if let seasons = conditions?[.inOrOut] {
                let season = Season.Manager.find(Date(), in: seasons.keys.map{$0})
                let condition = conditions?[Conditions.inOrOut]?[season]
                conditionsUsed = ((condition as! InOrOut).isOutdoors ? Location.outdoorConditions : Location.indoorConditions)
            }
            else {
                conditionsUsed = Location.indoorConditions
            }
        }
        else {
            conditionsUsed = Location.indoorConditions
            self.conditions = [:]
            Conditions.values.forEach{self.conditions[$0] = [Season.allYear:$0.defaultValue]}
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
    
    func value(_ detail: Conditions) -> Condition {
        let season: Season = currentSeason(detail)
        if let retVal = conditions[detail]![season] {
            return retVal
        }
        return detail.defaultValue
    }
    
    func addValue(_ detail: Conditions, _ season: Season, _ value: Condition) {
        conditions[detail] = [:]
        conditions[detail]![Season.allYear] = detail.defaultValue
    }
    
    func currentSeason(_ condition: Conditions) -> Season {
        return Season.Manager.find(Date(), in: validSeasons(condition) ?? Location.defaultSeasons)
    }
    
    func validSeasons(_ condition: Conditions) -> [Season]? {
        return conditions[condition]?.keys.map{$0}
    }
    
    func updateDetailsUsed(_ isOutside: Bool) {
        conditionsUsed = (isOutside ? Location.outdoorConditions : Location.indoorConditions)
    }
}
