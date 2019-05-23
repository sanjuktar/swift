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
        enum LocationManagerKeys: String, CodingKey {
            case unknownLocation = "unknown location"
        }
        
        static var defaultName = "Location.Manager"
        private var unknownLocationObj: UnknownLocation?
        var unknownLocation: UnknownLocation {
            return unknownLocationObj!
        }
        
        static func load(name: String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Manager.self))!
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let container = try decoder.container(keyedBy: LocationManagerKeys.self)
            unknownLocationObj = try container.decode(UnknownLocation.self, forKey: .unknownLocation)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(Location.Manager.defaultName, "Location")
        }
        
        override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: LocationManagerKeys.self)
            try container.encode(unknownLocationObj, forKey: .unknownLocation)
        }
        
        func addUnknownLocation() throws {
            if unknownLocationObj == nil {
                unknownLocationObj = UnknownLocation()
                do {
                    try add(unknownLocationObj!)
                } catch {
                    throw GenericError("Unable to add \"\(unknownLocationObj!)\" to \(self)")
                }
            }
        }
    }
}
