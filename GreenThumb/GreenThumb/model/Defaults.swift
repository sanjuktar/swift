//
//  Defaults.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class Defaults {
    
    static var filename: String = "defaults"
    static var version: String {
        return "v0.1"
    }
    static var conditions: [ConditionsType:Conditions] {
        return inUse!.conditions!
    }
    static var seasonal: Seasonal {
        return inUse!.seasonal!
    }
    static var location: UniqueId {
        return inUse!.location!
    }
    static var care: CareSchedule? {
        return inUse!.care!
    }
    private static var inUse: Defaults?
    
    var version: String = Defaults.version
    private var conditions: [ConditionsType:Conditions]?
    private var seasonal: Seasonal?
    private var location: UniqueId?
    private var care: CareSchedule?
    var name: String = "defaults"
    
    class Seasonal: Codable {
        enum CodingKeys: String, CodingKey {
            case season = "season"
            case seasonsList = "seasons list"
        }
        
        var season: UniqueId
        var seasonsList: [UniqueId]
        
        init(_ name: String = "defaults") {
            season = AllYear.id
            seasonsList = [AllYear.id]
        }
    }
    
    static func create() {
        inUse = Defaults()
        initConditions()
    }
    
    private static func initConditions() {
        inUse?.conditions = [:]
        for type in ConditionsType.allCases {
            switch type {
            case .inOrOut:
                inUse?.conditions![.inOrOut] = InOrOut(.indoors)
            case .light:
                inUse?.conditions![.light] = LightExposure(.mediumLight)
            case .rain:
                inUse?.conditions![.rain] = Rain(.dry)
            case .humidity:
                inUse?.conditions![.humidity] = Humidity(.medium)
            case .wind:
                inUse?.conditions![.wind] = Wind(.calm)
            }
        }
    }
    
    static func initSeasonal() {
        inUse?.seasonal = Seasonal()
    }
    
    static func initLocations() {
        inUse?.location = UnknownLocation.id
    }
    
    static func initCare() {
        inUse?.care = [:]
        for care in (CareType.seasonal + CareType.nonSeasonal) {
            switch care {
            case .none:
                inUse?.care![.none] = SeasonalSchedule([
                    AllYear.id:Timetable(NoAction(), ActionFrequency.never)
                ])
            case .water:
                inUse?.care![.water] = SeasonalSchedule([
                    AllYear.id:Timetable(Water(Water.Quantity.soak), ActionFrequency.weekly.times(2))
                ])
            case .fertilize:
                inUse?.care![care] = SeasonalSchedule([
                    AllYear.id:Timetable(Fertilize("kelp fertilizer", Volume.any), ActionFrequency.monthly)
                ])
            case .light:
                inUse?.care![care] = SeasonalSchedule([
                    AllYear.id:Timetable(Light(LightExposure()), ActionFrequency.daily)
                ])
            case .prune:
                inUse?.care![care] = SeasonalSchedule([
                    AllYear.id:Timetable(Pruning(), ActionFrequency.yearly)
                ])
            case .move:
                inUse?.care![care] = SeasonalSchedule([
                    AllYear.id:Timetable(Move(), ActionFrequency.never)
                ])
            case .pestControl:
                inUse?.care![care] = SeasonalSchedule([
                    AllYear.id:Timetable(PestControl(), ActionFrequency.monthly.times(2))
                ])
            }
        }
    }
}
