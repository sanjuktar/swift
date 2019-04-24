//
//  Location.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Location: IdedObj {
    enum Conditions: String, Codable {
        case sunny = "sunny"
        case indoors = "indoors"
        case covered = "covered"
        case windy = "windy"
        case draftyHot = "drafty(hot)"
        case draftyCold = "drafty(cold)"
        case dry = "dry"
        case humid = "humid"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case conditions
    }
    
    static var locationUnknown = "Location Unknown"
    static var unknownLocation = Location(Location.locationUnknown)
    static var manager: Location.Manager? {
        return AppDelegate.current?.locations
    }
    var id: UniqueId
    var name: String
    var conditions: [Conditions]
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UniqueId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        conditions = try container.decode([Conditions].self, forKey: .conditions)
    }
    
    init(_ name: String, conditions: [Conditions] = []) {
        self.id = (Location.manager?.newId())!
        self.name = name
        self.conditions = conditions
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(conditions, forKey: .conditions)
    }
    
    func persist() throws {
        try Documents.instance?.store(self, as: id)
        try Location.manager?.add(self)
    }
    
    func unpersist() throws {
        try Documents.instance?.remove(id)
        try Location.manager?.remove(self)
    }
}
