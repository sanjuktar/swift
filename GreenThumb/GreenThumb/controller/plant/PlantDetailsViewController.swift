//
//  PlantDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantDetailsViewController: EditableTableViewController {
    @IBOutlet weak var _editSaveButton: UIBarButtonItem!
    @IBOutlet weak var detailsTable: UITableView!

    static let noNameTitle = "Plant Details"
    static var returnToPlantListSegue = "unwindEditPlantToList"
    static var returnFromLocationList = "unwindLocListToPlantDetails"
    static var returnFromTypesList = "unwindPlantTypesToDetails"
    static var careDetailsSegue = "plantDetailsToCareSegue"
    static var locationDetailsSegue = "plantDetailsToLocationSegue"
    
    var plant: Plant?
    var plantImageTableCell: EditableImageCell?
    var textFields: [UITextField:PlantDetail] {
        return (textController as! DetailTextFieldDelegate<PlantDetail>).textFields
    }
    var name: String {
        return plant?.name ?? ""
    }
    
    @IBAction func locationListToPlantDetails(segue: UIStoryboardSegue) {
        processUnwindSegue(segue: segue)
    }
    
    @IBAction func plantTypeListToDetails(segue: UIStoryboardSegue) {
        processUnwindSegue(segue: segue)
    }
    
    func processUnwindSegue(segue: UIStoryboardSegue) {
        switch segue.identifier {
        case PlantDetailsViewController.returnFromLocationList:
            let source = segue.source as! LocationListPopoverViewController
            let loc =  Location.manager!.get(Location.manager!.ids[source.selected])
            guard loc != nil else {
                output?.out(.error, "Unable to change location.")
                return
            }
            for item in textFields {
                if item.value == .location {
                    item.key.text =  loc!.name
                }
            }
            let _ = PlantDetail.location.modify(plant!, with: loc)
            return
        case PlantDetailsViewController.returnFromTypesList:
            let source = segue.source as! PlantTypeListPopupViewController
            let type = Plant.Preferences.manager!.get(Plant.Preferences.manager!.ids[source.selected])
            guard type != nil else {
                output?.out(.error, "Unable to change plant type.")
                return
            }
            for item in textFields {
                if item.value == .type {
                    item.key.text = type?.name
                }
            }
            let _ = PlantDetail.type.modify(plant!, with: type)
            return
        default: return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log = Plant.manager?.log
        editSaveButton = _editSaveButton
        setEditMode(editMode)
        editSaveButton?.isEnabled = PlantDetail.validate(plant!)
        table = detailsTable
        tableController = DetailsTableController<PlantDetail>.setup(plant!, self)
        textController = DetailTextFieldDelegate<PlantDetail>(plant!, self)
        title = !plant!.name.isEmpty ? plant?.name : PlantDetailsViewController.noNameTitle
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case PlantDetailsViewController.returnToPlantListSegue:
            if !editMode {
                setEditMode(true)
                table!.reloadData()
                return false
            }
            return true
        case PlantDetailsViewController.locationDetailsSegue:
            return true
        case PlantDetailsViewController.careDetailsSegue:
            if let detail = sender as? PlantDetail {
                return detail.careType != nil
            }
            return false
        default:
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case PlantDetailsViewController.returnToPlantListSegue:
            if editMode {
                if !PlantDetail.validate(plant!) {
                    plant = nil
                    return
                }
            }
        case PlantDetailsViewController.locationDetailsSegue:
            (segue.destination as! LocationDetailsViewController).location = sender as? Location
        case PlantDetailsViewController.careDetailsSegue:
            (segue.destination as! ScheduleViewController).schedule = sender as? SeasonalSchedule
        default:
            break
        }
    }
    
    override func setEditMode(_ flag: Bool) {
        super.setEditMode(flag)
        if plantImageTableCell != nil {
            plantImageTableCell?.cameraButton.isHidden = !editMode
        }
    }
    
    override func selectedTableRow(_ indexPath: IndexPath) {
        guard let detail = PlantDetail.item(indexPath.section, indexPath.row) else {return}
        switch detail {
        case .location:
            if editMode {
                showPopup(detail)
            }
            else {
                performSegue(withIdentifier: PlantDetailsViewController.locationDetailsSegue, sender: Location.manager!.get(plant!.location))
            }
        case .type:
            if editMode {
                showPopup(detail)
            }
            else {
                // Show plant type details
            }
        case let d where d.careType != nil:
            performSegue(withIdentifier: PlantDetailsViewController.careDetailsSegue, sender: plant?.care?.schedule[detail.careType!])
        default:
            break
        }
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let detail = textFields[textField]
        switch detail {
        case .location:
            fallthrough
        case .type:
            showPopup(detail!)
            return false
        default:
            return true
        }
    }
    
    override func objectChanged() {
        title = name.isEmpty ? PlantDetailsViewController.noNameTitle : name
        editSaveButton?.isEnabled = PlantDetail.validate(plant!)
    }
    
    private func showPopup(_ detail: PlantDetail) {
        let source = (textController as! DetailTextFieldDelegate<PlantDetail>).textFieldFor(detail)
        switch detail {
        case .location:
            LocationListPopoverViewController.show(
                self, source!,
                (Location.manager?.ids.firstIndex(of: plant!.location))!)
        case .type:
            PlantTypeListPopupViewController.show(
                self, source!,
                (Plant.Preferences.manager?.ids.firstIndex(of: plant!.preferences))!)
        default:
            return
        }
    }
}
