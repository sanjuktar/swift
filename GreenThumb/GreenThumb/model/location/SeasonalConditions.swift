//
//  SeasonalConditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

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
