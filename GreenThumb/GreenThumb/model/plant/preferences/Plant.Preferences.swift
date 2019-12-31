//
//  Plant.Preferences.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Plant {
    class Preferences: IdedObj {
        enum CodingKeys: String, CodingKey {
            case version = "version"
            case id = "id"
            case name = "name"
            case parent = "parent"
            case care = "care"
            case prefered = "prefered"
            case avoid = "avoid"
            case notes = "notes"
        }
        
        static var manager: Preferences.Manager?
        var version: String
        var id: UniqueId
        var name: String
        var parent: UniqueId?
        var care: CareInstructions
        var prefered: SeasonalConditions
        var avoid: SeasonalConditions
        var notes: String
        var description: String {
            return name
        }
        var isValid: Bool {
            return true
        }
        var clone: Preferences {
            return Preferences(self)
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            version = try container.decode(String.self, forKey: .version)
            id = try container.decode(UniqueId.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            parent = try container.decode(UniqueId?.self, forKey: .parent)
            care = try container.decode(CareInstructions.self, forKey: .care)
            prefered = try container.decode(SeasonalConditions.self, forKey: .prefered)
            avoid = try container.decode(SeasonalConditions.self, forKey: .avoid)
            notes = try container.decode(String.self, forKey: .notes)
            if care.schedule.isEmpty {
                care.schedule = Defaults.care!
                Plant.Preferences.manager?.log?.out(.error, "Unable to load care schedule for \(name). Using defaults.")
                do {
                    try persist()
                } catch {
                    Plant.Preferences.manager?.log?.out(.error, "Unable to save \(name) with new default care schedule.")
                }
            }
        }
    
        required init(_ name: String = "", care: CareInstructions = CareInstructions(),
             preferedConditions: SeasonalConditions = SeasonalConditions(),
             avoidConditions: SeasonalConditions = SeasonalConditions(),
             notes: String = "") {
            id = (Preferences.manager!.newId())
            version = Defaults.version
            self.name = name
            self.care = care
            prefered = preferedConditions
            avoid = avoidConditions
            self.notes = notes
        }
    
        private init(_ preferences: Preferences) {
            version = preferences.version
            id = preferences.id
            name = preferences.name
            care = preferences.care
            prefered = preferences.prefered
            avoid = preferences.avoid
            parent = preferences.parent
            notes = preferences.notes
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(version, forKey: .version)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(parent, forKey: .parent)
            try container.encode(care, forKey: .care)
            try container.encode(prefered, forKey: .prefered)
            try container.encode(avoid, forKey: .avoid)
            try container.encode(notes, forKey: .notes)
        }
    
        func persist() throws {
            try Preferences.manager?.add(self)
        }
    
        func unpersist() throws {
            try Preferences.manager?.remove(self.id)
        }
    }
}
