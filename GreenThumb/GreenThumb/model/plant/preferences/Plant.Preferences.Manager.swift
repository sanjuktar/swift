//
//  Plant.Preferences.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Plant.Preferences {
    class Manager: IdedObjManager<Plant.Preferences> {
        static var defaultName = "Plant.Preferences.Manager"
        static var log: Log?
        
        static func load(name: String = defaultName) throws -> Plant.Preferences.Manager {
            return try (Documents.instance?.retrieve(name, as: Plant.Preferences.Manager.self))!
        }
        
        static func setup(name: String = defaultName, output: Output? = nil) {
            log = AppDelegate.current?.log
            var flag = false
            do {
                manager = try Manager.load(name: name)
            } catch {
                if manager != nil && manager!.isValid {
                    output?.out(.error, error.localizedDescription)
                    log?.out(.error, error.localizedDescription)
                }
                else {
                    output?.out(.error, "Unable to load plant types. Using defaults.")
                    log?.out(.error, "Using defaults because unable to load list of plant types: \(error).")
                    manager = Manager()
                    flag = true
                }
            }
            for type in PlantType.allCases {
                if manager!.ids.firstIndex(of: type.name) == nil {
                    do {
                        try manager!.add(Plant.Preferences(type.name, care: type.care, preferedConditions: type.prefers, avoidConditions: type.avoid))
                        flag = true
                    } catch {
                        log?.output(.error, "Unable to add plant type \"\(type.name)\"")
                    }
                }
            }
            if flag {
                do {
                    try manager?.commit()
                } catch {
                    log?.out(.error, "Unable to save new plantTypes manager.")
                }
            }
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(name, "Plant.Preferences")
            //super.init(name, ProvidedIds("Plant.Preferences"))
        }
        
        func defaults(_ type: PlantType) -> Plant.Preferences {
            let generator = idGenerator as! ProvidedIds
            if let preferences = get(generator.id(for: type.name)) {
                return preferences
            }
            return get(generator.id(for: PlantType.none.name))!
        }
    }
}
