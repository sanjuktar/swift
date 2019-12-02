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
    static var inUseList: [CareType] = Defaults.care.keys.map{$0}
    var version: String {
        return Defaults.version
    }
    var name: String {
        return rawValue
    }
    var description: String {
        return rawValue
    }
    
    static func get(_ action: Action) -> CareType {
        switch action {
        case is Water: return .water
        case is Fertilize: return .fertilize
        case is Light: return .light
        case is Pruning: return .prune
        case is Move: return .move
        case is PestControl: return .pestControl
        default: return .none
        }
    }
}
