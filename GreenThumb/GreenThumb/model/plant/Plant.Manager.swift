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
        
        static func load(name: String = defaultName) throws -> Plant.Manager {
            return try (Documents.instance?.retrieve(name, as: Plant.Manager.self))!
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        init(_ name: String = Manager.defaultName) {
            super.init(name, "Plant")
        }
        
        func plants(at location: Location) -> [UniqueId] {
            var list: [UniqueId] = []
            for id in ids {
                if id == location.id {
                    list.append(id)
                }
            }
            return list
        }
    }
}
