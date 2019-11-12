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
    var cellHeight: CGFloat {
        switch self {
        case .image:
            return ImageDetailCell.height
        default:
            return DetailsTableCell.genericHeight
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
    var isCare: Bool {
        switch self {
        case .water: return true
        case .light: return true
        case .fertilize: return true
        case .pestControl: return true
        case .prune: return true
        case .repot: return true
        default:
            return false
        }
    }
    var isStringConvertable: Bool {
        switch self {
        case .image: return false
        default: return true
        }
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
            return CareDetail.water.data(plant.care)
        case .light:
            return CareDetail.light.data(plant.care)
        case .fertilize:
            return CareDetail.fertilize.data(plant.care)
        case .pestControl:
            return CareDetail.pestControl.data(plant.care)
        case .prune:
            return CareDetail.prune.data(plant.care)
        case .repot:
            return CareDetail.repot.data(plant.care)
        }
    }
    
    func validate(_ obj: Plant) -> Bool {
        switch self {
        case let detail where detail.isName: return obj.names.validate()
        case .location: return Location.manager?.get(obj.location) != nil
        default: return true
        }
    }
    
    func modify(_ obj: Plant, with value: Any) -> Bool {
        switch self {
        case .image:
            if let image = value as? UIImage {
                obj.image = image
            }
            return false
        case .location:
            if let loc = value as? Location {
                obj.location = loc.id
            }
            else if let id = value as? String {
                obj.location = id
            }
            return false
        case .nickname:
            if let text = value as? String {
                obj.names.nickname = text
            }
            return false
        case .commonName:
            if let text = value as? String {
                obj.names.common = text
            }
            return false
        case .scientificName:
            if let text = value as? String {
                obj.names.scientific = text
            }
            return false
        default:
            break
        }
        return true
    }
    
    func cell(_ detailsVC: PlantDetailsViewController, obj: Plant?, editMode: Bool) -> DetailsTableCell {
        let label = "\(rawValue): "
        switch self {
        case .image:
            return ImageDetailCell.get(detailsVC.detailsTable, obj?.image, editMode)
        case let detail where detail.isCare:
            let cell = DetailsTableCell.get(detailsVC.detailsTable, label, value(for: obj!) as! String)
            cell.accessoryType = .disclosureIndicator
            detailsVC.performSegue = true
            return cell
        default:
            break
        }
        if editMode {
            let cell = EditDetailTextCell.get(detailsVC, label, value(for: obj!) as! String)
            detailsVC.textFields[cell.detailTextField] = self
            return cell
        }
        return DetailsTableCell.get(detailsVC.detailsTable, label, value(for: obj!) as! String)
    }

    
    private static func getSection(_ pos: Int) -> Section {
        return Section.allCases[pos] 
    }
}
