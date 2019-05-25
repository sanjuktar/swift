//
//  Action.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class Action: IdedObj {
    enum CodingKeys: String, CodingKey {
        case version
        case id
    }
    
    static var manager: ActionManager? 
    var version: String
    var id: UniqueId
    var description: String {fatalError("Needs override.")}
    
    static func ==(_ lhs: Action, _ rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(UniqueId.self, forKey: .id)
    }
    
    init() {
        version = Defaults.version
        id = (Action.manager?.newId())!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
    }
    
    func persist() throws {
        try Action.manager?.add(self)
    }
    
    func unpersist() throws {
        try Action.manager?.remove(self)
    }
}
