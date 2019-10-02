//
//  Defaults.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class Defaults: Storable {
    static var filename: String = "defaults"
    static var version: String {
        return "v0.1"
    }
    static var conditions: [ConditionsType:Conditions] {
        return inUse!.conditions!
    }
    static var frequency: [CareType:ActionFrequency] {
        return inUse!.frequency!
    }
    static var seasonal: Seasonal {
        return inUse!.seasonal!
    }
    static var location: UniqueId {
        return inUse!.location!
    }
    static var care: [CareType:Action?] {
        return inUse!.care!
    }
    private static var inUse: Defaults?
    
    var version: String = Defaults.version
    private var conditions: [ConditionsType:Conditions]?
    private var frequency: [CareType:ActionFrequency]?
    private var seasonal: Seasonal?
    private var location: UniqueId?
    private var care: [CareType:Action?]?
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
        do {
            try load()
        } catch {
            AppDelegate.current!.log?.out(.error, "Unable to load defaults: \(error.localizedDescription)")
            inUse = Defaults()
            do {
                try commit()
            } catch {
                AppDelegate.current!.log?.out(.error, "Unable to save defaults.")
            }
        }
        initFrequency()
        initConditions()
    }
    
    static func load() throws {
        inUse = try Documents.instance?.retrieve(filename, as: Defaults.self)
    }
    
    static func commit() throws {
        try Documents.instance?.store(inUse!, as: Defaults.filename)
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
    
    static func initFrequency() {
        let careList = CareType.allCases
        inUse?.frequency = [:]
        for care in careList {
            switch care {
            case .none:
                break
            case .water:
                inUse?.frequency![.water] = ActionFrequency.weekly.times(2)
            case .fertilize:
                inUse?.frequency![.fertilize] = ActionFrequency.monthly.times(2)
            case .light:
                inUse?.frequency![.light] = ActionFrequency.hourly.times(6)
            case .prune:
                inUse?.frequency![.prune] = ActionFrequency.yearly
            case .move:
                inUse?.frequency![.move] = ActionFrequency.yearly.times(0)
            case .pestControl:
                inUse?.frequency![.pestControl] = ActionFrequency.monthly.times(2)
            default:
                AppDelegate.current?.log?.out(.error, "Unknown care type \(care). Unable to set frequency.")
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
        for care in CareType.allCases {
            switch care {
            case .none:
                break
            case .water:
                inUse?.care![care] = Water(Water.soak)
            case .fertilize:
                inUse?.care![care] = Fertilize("kelp fertilizer", Volume.ml(2))
            case .light:
                inUse?.care![care] = Light(LightExposure())
            case .prune:
                inUse?.care![care] = Pruning()
            case .move:
                inUse?.care![care] = Move()
            case .pestControl:
                inUse?.care![care] = PestControl()
            default:
                AppDelegate.current?.log?.out(.error, "Unknown care type \(care). Unable to set up action.")
            }
        }
    }
}
