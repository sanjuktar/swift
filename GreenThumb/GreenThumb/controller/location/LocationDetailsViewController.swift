//
//  LocationDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationDetailsViewController: EditableTableViewController {
    @IBOutlet weak var _editSaveButton: UIBarButtonItem!
    @IBOutlet weak var detailsTable: UITableView!
    static var returnToLocationsListSegue = "unwindFromLocationDetailsToList"
    static var noNameTitle = "Location Details"
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log = Location.manager?.log
        table = detailsTable
        editSaveButton = _editSaveButton
        tableController = DetailsTableController<LocationDetail>.setup(location!, self)
        textController = DetailTextFieldDelegate<LocationDetail>(location!, self)
        sliderController = DetailsSliderController<LocationDetail>(location!, self)
        setEditMode(editMode)
        if editMode {
            editSaveButton?.isEnabled = LocationDetail.validate(location!)
        }
        title = (location?.name.isEmpty)! ? LocationDetailsViewController.noNameTitle : location?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case LocationDetailsViewController.returnToLocationsListSegue:
            if !LocationDetail.validate(location!) {
                location = nil
            }
        default:
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender is UIBarButtonItem && (sender as! UIBarButtonItem) == editSaveButton {
            if editMode {
                return LocationDetail.validate(location!)
            }
            setEditMode(true)
            table!.reloadData()
            return false
        }
        return true
    }
    
    override func objectChanged() {
        title = location!.name.isEmpty ? LocationDetailsViewController.noNameTitle : location!.name
        editSaveButton?.isEnabled = LocationDetail.validate(location!)
    }
    
    override func sliderValueChanged(_ slider: UISlider) {
        guard let condition = (sliderController as? DetailsSliderController<LocationDetail>)?.details[slider] else {return}
        var values: [Conditions]
        var detail: ConditionsType
        var prevVal: Conditions?
        switch condition {
        case .inOrOut:
            values = InOrOut.values.map{InOrOut($0)}
            detail = .inOrOut
            prevVal = location?.conditions.value(.inOrOut)
        case .light:
            values = LightExposure.values.map{LightExposure($0)}
            detail = .light
        case .rain:
            values = Rain.values.map{Rain($0)}
            detail = .rain
        case .humidity:
            values = Humidity.values.map{Humidity($0)}
            detail = .humidity
        case .wind:
            values = Wind.values.map{Wind($0)}
            detail = .wind
        default:
            log!.out(.error, "Unable to determine which details needs updating.")
            output?.out(.error, "Unable to update.")
            return
        }
        let season = location!.conditions.currentSeason(detail)
        var indx = Int(slider.value*Float(values.count))
        if indx == values.count {
            indx -= 1
        }
        let value = values[indx]
        location!.conditions.addValue(detail, season: (season?.id)!, value: value)
        slider.setThumbnailText(values[indx].name)
        if condition == .inOrOut {
            if value != prevVal {
                location?.updateDetailsUsed((value as! InOrOut).isOutdoors)
                detailsTable.reloadData()
            }
        }
        objectChanged()
    }
}

