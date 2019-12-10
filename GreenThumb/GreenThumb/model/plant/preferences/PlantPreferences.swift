//
//  PlantType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

class PlantPreferences: IdedObj {
    static var manager: PlantPreferences.Manager?
    var id: UniqueId
    var version: String
    var name: String
    var parent: PlantPreferences?
    var care: CareInstructions
    var prefered: SeasonalConditions
    var avoid: SeasonalConditions
    var description: String {
        return name
    }
    var isValid: Bool {
        return true
    }
    var clone: PlantPreferences {
        return PlantPreferences(self)
    }
    
    init(_ name: String = "", care: CareInstructions, preferedConditions: SeasonalConditions = SeasonalConditions(), avoidConditions: SeasonalConditions = SeasonalConditions()) {
        id = (PlantPreferences.manager!.newId())
        version = Defaults.version
        self.name = name
        self.care = care
        prefered = preferedConditions
        avoid = avoidConditions
    }
    
    private init(_ type: PlantPreferences) {
        id = type.id
        version = type.version
        name = type.name
        care = type.care
        prefered = type.prefered
        avoid = type.avoid
    }
    
    func persist() throws {
        try PlantPreferences.manager?.add(self)
    }
    
    func unpersist() throws {
        try PlantPreferences.manager?.remove(self.id)
    }
}
