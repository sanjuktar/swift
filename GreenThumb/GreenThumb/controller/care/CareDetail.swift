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
                return [.water(nil), .sun(nil), .fertilize(nil), .prune]
            case .afterTable:
                return [.notes]
            }
        }
    }
    
    case name
    case water(UniqueId?)
    case sun(UniqueId?)
    case pestControl(UniqueId?)
    case fertilize(UniqueId?)
    case prune
    case repot
    case notes
    
    func data(_ care: CareInstructions) -> String {
        switch self {
        case .name:
            return ""
        case .water(let season):
            return seasonalData(care, .water, season)
        case .sun(let season):
            return seasonalData(care, .light, season)
        case .pestControl(let season):
            return seasonalData(care, .pestControl, season)
        case .fertilize(let season):
            return seasonalData(care, .fertilize, season)
        case .prune:
            return seasonalData(care, .prune, AllYear.id)
        case .repot:
            return ""
        case .notes:
            return care.notes
        }
    }
    
    private func seasonalData(_ care: CareInstructions, _ item: CareType, _ season: UniqueId?) -> String {
        return care.schedule[item]?.timetable[season ?? care.currentSeason(item).id]?.description ?? ""
    }
}
