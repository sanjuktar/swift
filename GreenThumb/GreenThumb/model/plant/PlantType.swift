//
//  PlantType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum PlantType: String, Storable, CaseIterable {
    case none = "none"
    case succulent = "succulent"
    case cactus = "cactus"
    case leafyIndoor = "leafy indoor"
    
    var version: String {
        return Defaults.version
    }
    var name: String {
        return rawValue
    }
    
    var care: CareInstructions {
        switch self {
        case .none:
            return CareInstructions()
        case .succulent:
            let c = CareInstructions()
            c.schedule[.water] = SeasonalSchedule([
                    AllYear.id:Timetable(Water(Water.Quantity.soak),
                                         ActionFrequency(timeUnitX: 2, timeUnit: .weeks))
            ])
            return c
        case .cactus:
            let c = PlantType.succulent.care
            c.schedule[.water] = SeasonalSchedule([
                AllYear.id:Timetable(Water(Water.Quantity.soak), ActionFrequency(timeUnit: .months))
            ])
            return c
        case .leafyIndoor:
            return PlantType.none.care
        }
    }
    
    var prefers: SeasonalConditions {
        switch self {
        case .none:
            return SeasonalConditions()
        case .succulent:
            let c = SeasonalConditions()
            c.addValue(AllYear.id, Rain(.dry))
            c.addValue(AllYear.id, Humidity(.low))
            c.addValue(AllYear.id,LightExposure(.bright))
            return c
        case .cactus:
            return PlantType.succulent.prefers
        case .leafyIndoor:
            let c = SeasonalConditions()
            c.addValue(AllYear.id, InOrOut(.indoors))
            return c
        }
    }
    
    var avoid: SeasonalConditions {
        switch self {
        case .none:
            return SeasonalConditions()
        case .succulent:
            let c = SeasonalConditions()
            c.addValue(AllYear.id,Rain(.rainy))
            c.addValue(AllYear.id,Humidity(.high))
            return c
        case .cactus:
            return PlantType.succulent.avoid
        case .leafyIndoor:
            return PlantType.none.avoid
        }
    }
}
