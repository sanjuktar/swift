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
        enum CodingKeys: String, CodingKey {
            case name
            case locations
            case idGenerator
        }
        
        static var defaultName: String = "Location.Manager"
        var locations: [UniqueId: Location] = [:]
        //var defaut: String = Location.locationUnknown
        var log: Log? = AppDelegate.current?.log
        
        static func load(name :String = defaultName) throws -> Location.Manager {
            return try (Documents.instance?.retrieve(name, as: Location.Manager.self))!
        }
        
        static func create(_ name: String = defaultName, addUnknownLocation: Bool = true) -> Location.Manager {
            let loc = Location.Manager(name)
            if addUnknownLocation {
                do {
                    try loc.add(Location.unknownLocation)
                } catch {
                    loc.log?.output(.error, "Unable to cleanly add \(Location.unknownLocation.name) to \(loc.name)")
                }
            }
            return loc 
        }
        
        required init(from decoder: Decoder)  throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            let locIds = try container.decode([UniqueId].self, forKey: .locations)
            locations = [:]
            for id in locIds {
                locations[id] = try Documents.instance?.retrieve(id, as: Location.self)
            }
            idGenerator = try container.decode(IdGenerator.self, forKey: .idGenerator)
        }
        
        private init(_ name: String = Manager.defaultName) {
            super.init(name, "Location")
            locations = [:]
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(locations.keys.filter{_ in true}, forKey: .locations)
            try container.encode(idGenerator, forKey: .idGenerator)
        }
        
        override func commit() throws {
            try Documents.instance?.store(self, as: name)
        }
        
        func get(_ name: String) -> Location? {
            return locations[name]
        }
        
        override func add(_ obj: Location) throws {
            locations[obj.id] = obj
            try commit()
        }
        
        override func remove(_ obj: Location) throws {
            if locations.keys.contains(obj.id) {
                locations.remove(at: locations.index(forKey: obj.id)!)
            }
            try commit()
            try Documents.instance?.remove(obj.id)
        }
    }
}
