//
//  ActionCategory.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/3/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

enum ActionCategory: String, Storable, CaseIterable {
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
        case .none:
            return []
        case .care:
            return CareType.inUseList
        }
    }
    
    init?(typeName: String) {
        for category in ActionCategory.allCases {
            for type in category.actions {
                if type.name == typeName {
                    self = category
                    return
                }
            }
        }
        return nil
    }
    
    init?(type: ActionType) {
        switch type {
        case is NoAction:
            self = ActionCategory.none
        case is CareType:
            self = .care
        default:
            return nil
        }
    }
}
