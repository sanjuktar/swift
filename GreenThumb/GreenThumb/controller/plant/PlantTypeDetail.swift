//
//  PlantTypeDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/12/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

enum PlantTypeDetail: String, ObjectDetail, CaseIterable {
    
    enum Section: String, CaseIterable {
        case noheading = ""
    }
    
    case name = "Name"
    case care = "Care"
    case prefer = "Prefered conditions"
    case avoid = "Avoid"
    case notes = "Notes"
    
    static var sections: [String] {
        return []
    }
    
    var cellHeight: CGFloat {
        return DetailsConstants.Table.Cell.Height.detailCell
    }
    
    var segueOnSelection: Bool {
        return self == .care
    }
    
    static func items(in section: Int) -> [String] {
        return allCases.map{$0.rawValue}
    }
    
    static func item(_ section: Int, _ pos: Int) -> PlantTypeDetail? {
        guard section < 1 else {return nil}
        return allCases[pos]
    }
    
    func equals(_ detail: PlantTypeDetail) -> Bool {
        return rawValue == detail.rawValue
    }
    
    func value(for obj: Plant.Preferences) -> Any? {
        switch self {
        case .name:
            return obj.name
        case .care:
            return obj.care
        case .prefer:
            return obj.prefered
        case .avoid:
            return obj.avoid
        case .notes:
            return obj.notes
        }
    }
    
    func validate(_ obj: Plant.Preferences) -> Bool {
        switch self {
        case .name:
            return !obj.name.isEmpty
        case .care:
            return CareDetail.validate(obj.care)
        case .prefer:
            return true
        case .avoid:
            return true
        case .notes:
            return true
        }
    }
    
    func modify(_ obj: Plant.Preferences, with value: Any?) -> Bool {
        switch self {
        case .name:
            if let name = value as? String {
                obj.name = name
                return true
            }
            return false
        case .care:
            if let care = value as? CareInstructions {
                obj.care = care
                return true
            }
            return false
        case .prefer:
            if let conditions = value as? SeasonalConditions {
                obj.prefered = conditions
                return true
            }
            return false
        case .avoid:
            if let conditions = value as? SeasonalConditions {
                obj.avoid = conditions
                return true
            }
            return false
        case .notes:
            if let notes = value as? String {
                obj.notes = notes
                return true
            }
            return false
        }
    }
    
    func cell(_ controller: EditableTableViewController, obj: Plant.Preferences?, editMode: Bool) -> UITableViewCell {
        return EditableTextCell.get(controller, "", "", editMode: false)
    }
    
    typealias ObjectType = Plant.Preferences
    
    var description: String {
        return rawValue
    }
    
}
