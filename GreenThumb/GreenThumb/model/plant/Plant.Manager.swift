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
        static var defaultName = "Plant.Manager"
        static var log: Log?
        
        static func load(name: String = defaultName) throws -> Plant.Manager {
            return try (Documents.instance?.retrieve(name, as: Plant.Manager.self))!
        }
        
        static func setup(name: String = defaultName) {
            log = AppDelegate.current?.log
            do {
                manager = try Manager.load(name: name)
            } catch {
                log?.out(.error, "Unable to load list of plants: \(error)")
                manager = Manager()
                do {
                    try manager?.commit()
                } catch {
                    log?.out(.error, "Unable to save new plants manager.")
                }
            }
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(name, "Plant")
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
