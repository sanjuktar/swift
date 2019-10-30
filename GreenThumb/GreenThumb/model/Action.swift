//
//  Action.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

protocol ActionType: Storable {
    var name: String {get}
}

extension ActionType {
    static func create(_ name: String) throws -> ActionType? {
        if name == NoAction.Typ.name {
            return NoAction.Typ()
        }
        if let type = CareType(rawValue: name) {
            return type
        }
        else {
            throw GenericError("Unknown action type: \(name)")
        }
    }
}

enum ActionClass: String, Storable, CaseIterable {
    case none = "none"
    case care = "care"
    
    var version: String {
        return Defaults.version
    }
    var name: String {
        return rawValue
    }
    var actions: [ActionType] {
        switch self {
        case .care:
            return CareType.inUseList
        default:
            return []
        }
    }
}

class Action: Storable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case version
        //case id
        case name
    }
    
    var version: String
    var description: String {
        return name
    }
    var name: String
    var clas: ActionClass {
        fatalError("Needs override.")
    }
    var type: ActionType {
        fatalError("Needs override.")
    }
    
    static func ==(_ lhs: Action, _ rhs: Action) -> Bool {
        return lhs.description == rhs.description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        name = try container.decode(String.self, forKey: .name)
    }
    
    init(_ name: String = "") {
        version = Defaults.version
        self.name = name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
    }
}

class NoAction: Action {
    class Typ: ActionType, Storable {
        static var name: String {
            return "noAction"
        }
        var name: String {
            return Typ.name
        }
        var version: String {
            return Defaults.version
        }
    }
    
    override var description: String {
        return "no action to be performed"
    }
    override var clas: ActionClass {
        return .none
    }
    override var type: ActionType {
        return Typ()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    init() {
        super.init("noAction")
    }
}
