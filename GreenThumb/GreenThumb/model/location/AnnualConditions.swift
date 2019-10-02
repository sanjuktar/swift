//
//  AnnualConditions.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/21/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class AnnualConditions: Storable {
    var version: String
    var conditions: [ConditionsType:SeasonalConditions]
    var name: String = ""
    var isOutdoors: Bool {
        return ((value(.inOrOut) as? InOrOut) ?? InOrOut()).isOutdoors
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        conditions = [:]
        for condition in ConditionsType.allCases {
            conditions[condition] = SeasonalConditions(Defaults.seasonal.seasonsList, condition.defaultValue)
        }
    }
    
    func value(_ detail: ConditionsType) -> Conditions {
        if let season = currentSeason(detail) {
            if let retVal = conditions[detail]?.conditions[season.id] {
                return retVal
            }
        }
        return detail.defaultValue
    }
    
    func addValue(_ detail: ConditionsType, season: UniqueId? = nil, value: Conditions? = nil) {
        let val = (value == nil ? detail.defaultValue : value)
        let saison = (season == nil ? currentSeason(detail)?.id ?? AllYear.id : season)
        if conditions[detail] == nil {
            conditions[detail] = SeasonalConditions()
        }
        conditions[detail]?.addValue(saison!, val!)
    }
    
    func currentSeason(_ condition: ConditionsType) -> Season? {
        return conditions[condition]?.currentSeason
    }
    
    func validSeasons(_ condition: ConditionsType) -> [UniqueId]? {
        return conditions[condition]?.seasons
    }
}
