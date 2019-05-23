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
    case water(Season?)
    case sun(Season?)
    case pestControl(Season?)
    case fertilize(Season?)
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
            return seasonalData(care, .sun, season)
        case .pestControl(let season):
            return seasonalData(care, .pestControl, season)
        case .fertilize(let season):
            return seasonalData(care, .fertilize, season)
        case .prune:
            return (care.nonSeasonal[.prune]?.description)!
        case .repot:
            return (care.nonSeasonal[.repot]?.description)!
        case .notes:
            return care.notes
        }
    }
    
    private func seasonalData(_ care: CareInstructions, _ item: PlantDetail, _ season: Season?) -> String {
        return care.seasonal[item]?.timetable[season ?? care.currentSeason(item)]?.description ?? ""
    }
}
