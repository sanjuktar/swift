//
//  CareDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/20/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

enum CareDetail: String, Codable, ObjectDetail {
    typealias ObjectType = CareInstructions
    
    enum Section: String, CaseIterable {
        case noHeader = ""
        case schedule = "Schedule"
        case notes = "Notes"
    }
    
    case ignore = "ignore"
    case name = "Name"
    // Schedule
    case water = "Water"
    case light = "Light"
    case pestControl = "Pest control"
    case fertilize = "Fertilize"
    case prune = "Prune"
    case move = "Move"
    case repot = "Repot"
    // Notes
    case notes = "Notes"
    
    static var details: [Section:[CareDetail]] = [
        .noHeader: [],
        .schedule: [.water, .light, .pestControl, fertilize, .prune, .repot, .move],
        .notes: [.notes]
    ]
    static var sections: [String]  {
        return Section.allCases.map{$0.rawValue}
    }
        
    var description: String {
        return rawValue
    }
    var careType: CareType? {
        switch self {
        case .ignore: return nil
        case .name: return nil
        case .water: return .water
        case .light: return .light
        case .pestControl: return .pestControl
        case .fertilize: return .fertilize
        case .prune: return .prune
        case .move: return .move
        case .repot: return nil
        case .notes: return nil
        }
    }
    var segueOnSelection: Bool {
        return false
    }
    var cellHeight: CGFloat {
        return DetailsConstants.Table.Cell.Height.detailCell
    }
    
    static func items(in section: Int) -> [String] {
        return details[Section.allCases[section]]?.map{$0.rawValue} ?? []
    }
    
    static func item(_ section: Int, _ pos: Int) -> CareDetail? {
        return details[Section.allCases[section]]?[pos]
    }
    
    static func validate(_ object: CareInstructions) -> Bool {
        for items in details.values {
            for detail in items {
                if !detail.validate(object) {
                    return false
                }
            }
        }
        return true
    }
    
    init(_ careType: CareType) {
        switch careType {
        case .none:
            self = .ignore
        case .water:
            self = .water
        case .light:
            self = .light
        case .pestControl:
            self = .pestControl
        case .fertilize:
            self = .fertilize
        case .prune:
            self = .prune
        case .move:
            self = .move
        }
    }
    
    func equals(_ detail: CareDetail) -> Bool {
        return rawValue == detail.rawValue
    }
    
    func value(for obj: CareInstructions) -> Any? {
        let season =  careType != nil ? obj.currentSeason(careType!).id : AllYear.id
        switch self {
        case .ignore:
            fatalError("Ignore care detail")
        case .name:
            return obj.name
        case .water:
            return seasonalData(obj, .water, season)
        case .light:
            return seasonalData(obj, .light, season)
        case .pestControl:
            return seasonalData(obj, .pestControl, season)
        case .fertilize:
            return seasonalData(obj, .fertilize, season)
        case .prune:
            return seasonalData(obj, .prune, season)
        case .repot:
            return "No details"
        case .move:
            return seasonalData(obj, .move, season)
        case .notes:
            return obj.notes
        }
    }
    
    func validate(_ obj: CareInstructions) -> Bool {
        return true
    }
    
    func modify(_ obj: CareInstructions, with value: Any?) -> Bool {
        switch self {
        case .ignore:
            return false
        case .name:
            if let s = value as? String {
                obj.name = s
                return true
            }
            return true
        case .water:
            fallthrough
        case .light:
            fallthrough
        case .pestControl:
            fallthrough
        case .fertilize:
            fallthrough
        case .prune:
            fallthrough
        case .move:
            if let v = value as? SeasonalSchedule {
                obj.schedule[careType!] = v
                return true
            }
            return false
        case .repot:
            return false
        case .notes:
            if let s = value as? String {
                obj.notes = s
            }
            return true
        }
    }
    
    func cell(_ controller: EditableTableViewController, obj: CareInstructions?, editMode: Bool) -> UITableViewCell {
        let label = "\(rawValue): "
        switch self {
        case .ignore:
            fatalError("Ignore care detail!")
        case .name:
            return EditableTextCell.get(controller, label, value(for: obj!) as! String, editMode: editMode)
        case .water:
            fallthrough
        case .light:
            fallthrough
        case .pestControl:
            fallthrough
        case .fertilize:
            fallthrough
        case .prune:
            fallthrough
        case .move:
            fallthrough
        case .repot:
            return EditableTextCell.getWithDisclosure(controller, label, value(for: obj!) as! String)
        case .notes:
            return EditableLongTextCell.get(controller, nil, value(for: obj!) as! String, editMode)
        }
    }
    
    private func seasonalData(_ care: CareInstructions, _ item: CareType, _ season: UniqueId?) -> String {
        return care.schedule[item]?.timetable[season ?? care.currentSeason(item).id]?.description ?? ""
    }
}
