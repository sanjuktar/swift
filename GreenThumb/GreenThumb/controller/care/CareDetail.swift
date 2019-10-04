//
//  CareDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation

enum CareDetail {
    enum Sections {
        case beforeTable
        case inTable
        case afterTable
        
        var items: [CareDetail] {
            switch self {
            case .beforeTable:
                return [.name]
            case .inTable:
                return CareType.inUseList.map{CareDetail($0)}
            case .afterTable:
                return [.notes]
            }
        }
    }
    
    case ignore
    case name
    case water
    case light
    case pestControl
    case fertilize
    case prune
    case move
    case repot
    case notes
    
    init(_ careType: CareType) {
        switch careType {
        case .none:
            self = .ignore
        case .water:
            self = .water
        case .fertilize:
            self = .fertilize
        case .light:
            self = .light
        case .prune:
            self = .prune
        case .move:
            self = .move
        case .pestControl:
            self = .pestControl
        }
    }
    
    func data(_ care: CareInstructions, _ season: UniqueId? = nil) -> String {
        switch self {
        case .ignore:
            fatalError("Ignore care detail")
        case .name:
            return care.name
        case .water:
            return seasonalData(care, .water, season)
        case .light:
            return seasonalData(care, .light, season)
        case .pestControl:
            return seasonalData(care, .pestControl, season)
        case .fertilize:
            return seasonalData(care, .fertilize, season)
        case .prune:
            return seasonalData(care, .prune, season)
        case .repot:
            return ""
        case .move:
            return seasonalData(care, .move, season)
        case .notes:
            return care.notes
        }
    }
    
    private func seasonalData(_ care: CareInstructions, _ item: CareType, _ season: UniqueId?) -> String {
        return care.schedule[item]?.timetable[season ?? care.currentSeason(item).id]?.description ?? ""
    }
}
