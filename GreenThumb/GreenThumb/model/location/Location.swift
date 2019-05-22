//
//  Location.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class AnnualConditions: Codable {
    static var defaultSeasons = [Season.allYear.id]
    var conditions: [Location.ConditionsType:SeasonalConditions]
    var isOutdoors: Bool {
        return ((value(.inOrOut) as? InOrOut) ?? InOrOut()).isOutdoors
    }
    
    init(_ conditionsUsed: [Location.ConditionsType] = Location.ConditionsType.indoorTypes) {
        conditions = [:]
        conditionsUsed.forEach{conditions[$0] = SeasonalConditions(AnnualConditions.defaultSeasons, $0.defaultValue)}
    }
    
    func value(_ detail: Location.ConditionsType) -> Conditions {
        if let season = currentSeason(detail) {
            if let retVal = conditions[detail]?.conditions[season.id] {
                return retVal
            }
        }
        return detail.defaultValue
    }
    
    func addValue(_ detail: Location.ConditionsType, season: UniqueId? = nil, value: Conditions? = nil) {
        let val = (value == nil ? detail.defaultValue : value)
        let saison = (season == nil ? currentSeason(detail)?.id ?? Season.allYear.id : season)
        if conditions[detail] == nil {
            conditions[detail] = SeasonalConditions()
        }
        conditions[detail]?.addValue(saison!, val!)
    }
    
    func currentSeason(_ condition: Location.ConditionsType) -> Season? {
        return conditions[condition]?.currentSeason
    }
    
    func validSeasons(_ condition: Location.ConditionsType) -> [Season]? {
        return conditions[condition]?.seasons
    }
}

class SeasonalConditions: Codable {
    enum CodingKeys: String, CodingKey {
        case conditions = "conditions"
    }
    
    var conditions: [UniqueId:Conditions]
    var seasons: [Season]? {
        return Season.manager?.objects(conditions.keys.map{$0})
    }
    var currentSeason: Season {
        return Season.Manager.find(Date(), in: seasons ?? [])
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codable = try container.decode([UniqueId:CodableConditions].self, forKey: .conditions)
        conditions = [:]
        for condition in codable {
            conditions[condition.key] = condition.value.condition
        }
    }
    
    init(_ conditions: [UniqueId:Conditions] = [:]) {
        self.conditions = conditions
    }
    
    init(_ seasons: [UniqueId], _ value: Conditions) {
        conditions = [:]
        seasons.forEach{conditions[$0] = value}
    }
    
    func encode(to encoder: Encoder) throws {
        var codable: [UniqueId:CodableConditions] = [:]
        for condition in conditions {
            codable[condition.key] = try CodableConditions(condition.value)
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(codable, forKey: .conditions)
    }
    
    func addValue(_ season: UniqueId, _ value: Conditions) {
        conditions[season] = value
    }
}

class Location: IdedObj {
    enum ConditionsType: String, Codable {
        case inOrOut
        case light
        case rain
        case humidity
        case wind
        
        var defaultValue: Conditions {
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
        
        static var values: [ConditionsType] = [.inOrOut, .light, .rain, .humidity, .wind]
        static var indoorTypes: [Location.ConditionsType] = [.inOrOut, .light, .humidity]
        static var outdoorTypes: [Location.ConditionsType] = [.inOrOut, .light, .rain, .humidity, .wind]
    }
    
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case name
        case conditionsUsed
        case conditions
    }
    
    static var locationUnknown = "Location Unknown"
    static var unknownLocation = Location(Location.locationUnknown)
    static var manager: Location.Manager? {
        return AppDelegate.current?.locations
    }
    var version: String
    var id: UniqueId
    var name: String
    var conditions: AnnualConditions
    var conditionsUsed: [ConditionsType]
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        conditionsUsed = try container.decode([ConditionsType].self, forKey: .conditionsUsed)
        conditions = try container.decode(AnnualConditions.self, forKey: .conditions)
    }
    
    init(_ name: String, conditions:AnnualConditions? = nil) {
        version = Location.defaultVersion
        self.id = (Location.manager?.newId())!
        self.name = name
        if conditions != nil {
            self.conditions = conditions!
            conditionsUsed = ((conditions?.isOutdoors ?? false) ? Location.ConditionsType.outdoorTypes : Location.ConditionsType.indoorTypes)
        }
        else {
            conditionsUsed = ConditionsType.indoorTypes
            self.conditions = AnnualConditions(conditionsUsed)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(conditionsUsed, forKey: .conditionsUsed)
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
    
    func updateDetailsUsed(_ isOutside: Bool) {
        conditionsUsed = (isOutside ? ConditionsType.outdoorTypes : ConditionsType.indoorTypes)
    }
}
