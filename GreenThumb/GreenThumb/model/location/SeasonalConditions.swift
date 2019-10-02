//
//  SeasonalConditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class SeasonalConditions: Storable {
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case conditions = "conditions"
    }
    
    var version: String
    var name = "SeasonalConditions"
    var conditions: [UniqueId:Conditions]
    var seasons: [UniqueId]? {
        return Season.manager?.ids
    }
    var currentSeason: Season {
        return Season.Manager.find(Date(), in: seasons ?? [])
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        let codable = try container.decode([UniqueId:StorableConditions].self, forKey: .conditions)
        conditions = [:]
        for condition in codable {
            conditions[condition.key] = condition.value.condition
        }
    }
    
    init(_ conditions: [UniqueId:Conditions] = [:]) {
        version = Defaults.version
        self.conditions = conditions
    }
    
    init(_ seasons: [UniqueId], _ value: Conditions) {
        version = Defaults.version
        conditions = [:]
        seasons.forEach{conditions[$0] = value}
    }
    
    func encode(to encoder: Encoder) throws {
        var codable: [UniqueId:StorableConditions] = [:]
        for condition in conditions {
            codable[condition.key] = try StorableConditions(condition.value)
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(codable, forKey: .conditions)
    }
    
    func addValue(_ season: UniqueId, _ value: Conditions) {
        conditions[season] = value
    }
}
