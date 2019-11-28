//
//  Location.Manager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

extension Location {
    class Manager: IdedObjManager<Location> {
        static var defaultName = "Location.Manager"
        var knownLocations: [UniqueId] {
            var locs = ids
            locs.remove(at: locs.firstIndex(of: UnknownLocation.id)!)
            return locs
        }
        
        static func load(name: String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Manager.self))!
        }
        
        static func setup() {
            let log = AppDelegate.current?.log
            var manager: Location.Manager?
            do {
                manager = try Location.Manager.load()
            } catch {
                log!.out(.error, "Unable to load list of locations: \(error.localizedDescription)")
                manager = Location.Manager()
            }
            if manager?.get(UnknownLocation.id) == nil {
                do {
                    try manager?.add(UnknownLocation.obj)
                } catch {
                    log!.out(.error, "Error adding \(UnknownLocation.obj.name) to \(manager!): \(error)")
                }
            }
            Location.manager = manager
            Defaults.initLocations()
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(Location.Manager.defaultName, "Location")
        }
    }
}
