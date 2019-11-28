//
//  PlantDetail.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/16/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

enum PlantDetail: String, Codable, ObjectDetail {
    typealias T = Plant
    
    enum Section: String, CaseIterable {
        case noHeading = ""
        case names = "Names"
        case care = "Care Schedule"
    }
    
    case ignore = "ignore"
    case image = "image"
    case location = "Location"
    // Names
    case nickname = "Nickname"
    case commonName = "Common"
    case scientificName = "Scientific"
    // Care
    case water = "Water"
    case light = "Light"
    case fertilize = "Fertilizer"
    case pestControl = "Pest Control"
    case prune = "Pruning"
    case repot = "Repot"
    
    static var details: [Section:[PlantDetail]] =
        [.noHeading:[.image, .location],
         .names:[.nickname, .commonName, .scientificName],
         .care:CareType.inUseList.map{PlantDetail($0)}]
    static var sections: [String] {
        return Section.allCases.map{$0.rawValue}
    }
    var description: String {
        return rawValue
    }
    var segueOnSelection: Bool {
        switch self {
        case .location:
            return true
        case let detail where detail.careType != nil:
            return true
        default:
            return false
        }
    }
    var cellHeight: CGFloat {
        switch self {
        case .image:
            return DetailsConstants.Table.Cell.Height.imageCell
        default:
            return DetailsConstants.Table.Cell.Height.detailCell
        }
    }
    var isName: Bool {
        switch self {
        case .nickname: return true
        case .commonName: return true
        case .scientificName: return true
        default: return false
        }
    }
    var isStringConvertable: Bool {
        switch self {
        case .image: return false
        default: return true
        }
    }
    var careType: CareType? {
        switch self {
        case .ignore: return nil
        case .image: return nil
        case .location: return nil
        case .nickname: return nil
        case .commonName: return nil
        case .scientificName: return nil
        case .water: return .water
        case .light: return .light
        case .fertilize: return .fertilize
        case .pestControl: return .pestControl
        case .prune: return .prune
        case .repot: return nil
        }
    }
    
    static func validate(_ plant: Plant) -> Bool {
        for section in details.values {
            for detail in section {
                if !detail.validate(plant) {
                    return false
                }
            }
        }
        return true
    }
    
    private init(_ type: CareType) {
        switch type {
        case .water:
            self = PlantDetail.water
        case .fertilize:
            self = PlantDetail.fertilize
        case .light:
            self = PlantDetail.light
        case .prune:
            self = PlantDetail.prune
        case .pestControl:
            self = PlantDetail.pestControl
        default:
            self = PlantDetail.ignore
        }
    }
    
    static func items(in section: Int) -> [String] {
        return details[getSection(section)]?.map{$0.rawValue} ?? []
    }
    
    static func item(_ section: Int, _ pos: Int) -> PlantDetail? {
        return details[(getSection(section))]?[pos]
    }
    
    func equals(_ detail: PlantDetail) -> Bool {
        return rawValue == detail.rawValue
    }
    
    func value(for obj: Plant) -> Any? {
        let plant = obj
        switch self {
        case .ignore:
            fatalError("Invalid detail!!!!!")
        case .image:
            return plant.image
        case .nickname:
            return plant.names.nickname
        case .commonName:
            return plant.names.common
        case .scientificName:
            return plant.names.scientific
        case .location:
            return Location.manager!.get(plant.location)!.name
        case .water:
            return CareDetail.water.value(for: plant.care)
        case .light:
            return CareDetail.light.value(for: plant.care)
        case .fertilize:
            return CareDetail.fertilize.value(for: plant.care)
        case .pestControl:
            return CareDetail.pestControl.value(for: plant.care)
        case .prune:
            return CareDetail.prune.value(for: plant.care)
        case .repot:
            return CareDetail.repot.value(for: plant.care)
        }
    }
    
    func validate(_ obj: Plant) -> Bool {
        switch self {
        case let detail where detail.isName: return obj.names.validate()
        case .location: return Location.manager?.get(obj.location) != nil
        default: return true
        }
    }
    
    func modify(_ obj: Plant, with value: Any?) -> Bool {
        switch self {
        case .image:
            if let image = value as? UIImage {
                obj.image = image
            }
            else {
                return false
            }
        case .location:
            switch value {
            case let v where v is Location:
                obj.location = (v as! Location).id
            case let v where v is String:
                obj.location = v as! String
            default:
                return false
            }
        case .nickname:
            if let text = value as? String {
                obj.names.nickname = text
            }
            else {
                return false
            }
        case .commonName:
            if let text = value as? String {
                obj.names.common = text
            }
            else {
                return false
            }
        case .scientificName:
            if let text = value as? String {
                obj.names.scientific = text
            }
            else {
                return false
            }
        default:
            break
        }
        return true
    }
    
    func cell(_ parent: EditableTableViewController, obj: Plant?, editMode: Bool) -> UITableViewCell {
        let label = "\(rawValue): "
        switch self {
        case .image:
            return EditableImageCell.get(parent, obj?.image, editMode)
        case .location where !editMode:
            return EditableTextCell.getWithDisclosure(parent, label, value(for: obj!) as! String)
        case let detail where detail.careType != nil:
            return EditableTextCell.getWithDisclosure(parent, label, value(for: obj!) as! String)
        default:
            let cell = EditableTextCell.get(parent, label, value(for: obj!) as! String, editMode: editMode)
            (parent.textController as! DetailTextFieldDelegate<PlantDetail>).add(textField: cell.detailValueTextField, edits: self)
            return cell
        }
    }
    
    private static func getSection(_ pos: Int) -> Section {
        return Section.allCases[pos] 
    }
}
