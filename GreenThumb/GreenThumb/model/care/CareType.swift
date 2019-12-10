//
//  CareType.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 5/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum CareType: String, ActionType, Storable, CaseIterable {
    case none = "None"
    case water = "Water"
    case fertilize = "Fertilize"
    case light = "Light exposure"
    case prune = "Prune"
    case move = "Move"
    case pestControl = "pestControl"
    
    static var seasonal: [CareType] = [.water, .fertilize, .light, .pestControl]
    static var nonSeasonal: [CareType] = [.prune]
    static var inUseList: [CareType] = Defaults.care!.keys.map{$0}
    var version: String {
        return Defaults.version
    }
    var name: String {
        return rawValue
    }
    var description: String {
        return rawValue
    }
    
    static func decode(actionType: String, _ container: KeyedDecodingContainer<StorableAction.CodingKeys>) throws -> Action {
        guard let type = CareType(rawValue: actionType) else {
            throw GenericError("Unable to get care type for \(actionType)")
        }
        switch type {
            case CareType.none:
                return try container.decode(NoAction.self, forKey: .action)
            case CareType.water:
                return try container.decode(Water.self, forKey: .action)
            case CareType.fertilize:
                return try container.decode(Fertilize.self, forKey: .action)
            case CareType.light:
                return try container.decode(Light.self, forKey: .action)
            case CareType.move:
                return try container.decode(Move.self, forKey: .action)
            case CareType.pestControl:
                return try container.decode(PestControl.self, forKey: .action)
            case CareType.prune:
                return try container.decode(Pruning.self, forKey: .action)
        }
    }
    
    init(_ action: Action) {
        switch action {
        case is Water:
            self = .water
        case is Fertilize:
            self = .fertilize
        case is Light:
            self = .light
        case is Pruning:
            self = .prune
        case is Move:
            self = .move
        case is PestControl:
            self = .pestControl
        default:
            self = .none
        }
    }
    
    func encode(action: Action, _ container: inout KeyedEncodingContainer<StorableAction.CodingKeys>) throws {
        try action.encode(to: container.superEncoder())
        switch self {
        case CareType.none:
            try container.encode(action as! NoAction, forKey: .action)
        case CareType.water:
            try container.encode((action as! Water), forKey: .action)
        case CareType.fertilize:
            try container.encode((action as! Fertilize), forKey: .action)
        case CareType.light:
            try container.encode((action as! Light), forKey: .action)
        case CareType.move:
            try container.encode(action as! Move, forKey: .action)
        case CareType.pestControl:
            try container.encode(action as! PestControl, forKey: .action)
        case CareType.prune:
            try container.encode(action as! Pruning, forKey: .action)
        }
    }
}
