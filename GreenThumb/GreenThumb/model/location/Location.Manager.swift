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
        
        static func load(name: String = defaultName) throws -> Manager {
            return try (Documents.instance?.retrieve(name, as: Manager.self))!
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(Location.Manager.defaultName, "Location")
        }
    }
}
