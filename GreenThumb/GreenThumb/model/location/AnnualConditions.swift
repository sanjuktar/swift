//
//  AnnualConditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class AnnualConditions: Codable {
    static var defaultSeasons = [Season.allYear.id]
    var conditions: [Location.ConditionsType:SeasonalConditions]
    var isOutdoors: Bool {
        return ((value(.inOrOut) as? InOrOut) ?? InOrOut()).isOutdoors
    }
    
    init() {
        conditions = [:]
        Location.ConditionsType.values.forEach{conditions[$0] = SeasonalConditions(AnnualConditions.defaultSeasons, $0.defaultValue)}
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
