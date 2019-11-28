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
    
    @IBAction func unwindToPlantDetails(segue: UIStoryboardSegue) {
        if let source = segue.source as? LocationListPopoverViewController {
            let loc = source.location!.id
            plant?.location = loc
            for item in textFields {
                if item.value == .location {
                    item.key.text =  Location.manager!.get(loc)!.name
                    editSaveButton!.isEnabled = PlantDetail.validate(plant!)
                }
            }
            return
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
    
    private func showLocationPopup(_ sender: UIView) {
        let controller =  self.storyboard!.instantiateViewController(
            withIdentifier: "locationListPopoverViewController")
        (controller as! LocationListPopoverViewController).location = Location.manager!.get(plant!.location)
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sender
        presentationController.sourceRect = sender.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    override func selectedTableRow(_ indexPath: IndexPath) {
        guard let detail = PlantDetail.item(indexPath.section, indexPath.row) else {return}
        switch detail {
        case .location:
            if editMode {
                showLocationPopup((textController as! DetailTextFieldDelegate<PlantDetail>).textFieldFor(detail)!)
            }
            else {
                performSegue(withIdentifier: PlantDetailsViewController.locationDetailsSegue, sender: Location.manager!.get(plant!.location))
            }
        case let d where d.careType != nil:
            performSegue(withIdentifier: PlantDetailsViewController.careDetailsSegue, sender: plant?.care.schedule[detail.careType!])
        default:
            break
        }
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFields[textField] == PlantDetail.location {
            showLocationPopup(textField)
            return false
        }
        return true
    }
    
    override func objectChanged() {
        title = name.isEmpty ? PlantDetailsViewController.noNameTitle : name
        editSaveButton?.isEnabled = PlantDetail.validate(plant!)
    }
}
