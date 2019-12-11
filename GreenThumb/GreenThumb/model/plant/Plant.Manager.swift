//
//  Plant.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

extension Plant {
    class Manager: IdedObjManager<Plant> {
        enum PlantManagerKeys: String, CodingKey {
            case preferencesManager = "preferencesManager"
        }
        
        static var defaultName = "Plant.Manager"
        static var log: Log?
        var preferencesManager: String?
        
        static func load(name: String = defaultName) throws -> Plant.Manager {
            return try (Documents.instance?.retrieve(name, as: Plant.Manager.self))!
        }
        
        static func setup(name: String = defaultName, output: Output? = nil) {
            log = AppDelegate.current?.log
            do {
                manager = try Manager.load(name: name)
            } catch {
                if manager != nil && manager!.isValid {
                    output?.out(.error, error.localizedDescription)
                    log?.out(.error, error.localizedDescription)
                }
                else {
                    output?.out(.error, "Unable to load list of plants.")
                    log?.out(.error, "Unable to load list of plants: \(error).")
                    manager = Manager()
                    do {
                        try manager?.commit()
                    } catch {
                        log?.out(.error, "Unable to save new plants manager.")
                    }
                }
            }
            Plant.Preferences.Manager.setup(
                name: manager!.preferencesManager ?? Preferences.Manager.defaultName, output: output)
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: PlantManagerKeys.self)
            preferencesManager = try container.decode(String.self, forKey: .preferencesManager)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(name, "Plant")
            preferencesManager = Preferences.Manager.defaultName
        }
        
        override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: PlantManagerKeys.self)
            try container.encode(preferencesManager, forKey: .preferencesManager)
        }
        
        func plants(at location: UniqueId) -> [UniqueId] {
            var list: [UniqueId] = []
            for id in ids {
                if objs[id]?.location == location {
                    list.append(id)
                }
            }
            return list
        }
    }
}
