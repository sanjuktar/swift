//
//  LocationDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 4/25/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class LocationDetailsViewController: UIViewController {
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    
    @IBAction func switchToggled(_ sender: UISwitch) {
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        guard let condition = sliders[sender] else {return}
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
        var indx = Int(sender.value*Float(values.count))
        if indx == values.count {
            indx -= 1
        }
        let value = values[indx]
        location!.conditions.addValue(detail, season: (season?.id)!, value: value) 
        sender.setThumbnailText(values[indx].name)
        editSaveButton.isEnabled = true
        if condition == .inOrOut {
            if value != prevVal {
                location?.updateDetailsUsed((value as! InOrOut).isOutdoors)
                detailsTable.reloadData()
            }
        }
    }
    
    var location: Location?
    var editMode: Bool = false
    var textfields: [UITextField:LocationDetail] = [:]
    var sliders: [UISlider:LocationDetail] = [:]
    var log: Log? = AppDelegate.current?.log
    var output: MessageWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        detailsTable.delegate = self
        detailsTable.dataSource = self
        setEditMode(editMode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender is UIBarButtonItem && (sender as! UIBarButtonItem) == editSaveButton {
            if editMode {
                return validateDetails()
            }
            setEditMode(true)
            detailsTable.reloadData()
            return false
        }
        return true
    }
    
    func validateDetails() -> Bool {
        return !location!.name.isEmpty
    }
    
    func setEditMode(_ flag: Bool) {
        editMode = flag
        if flag {
            editSaveButton.title = "Save"
            editSaveButton.isEnabled = false
            navigationItem.title = "Edit Location Details"
        }
        else {
            editSaveButton.title = "Edit"
            editSaveButton.isEnabled = true
            navigationItem.title = "Location Details"
        }
    }
}

extension LocationDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? LocationDetail.details(location!).count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = LocationDetail.details(location!)[indexPath.row]
        let cell = detail.tableCell(for: location!, in: tableView, editFlag: editMode)
        switch cell {
        case is EditLocDetailTextCell:
            let c = cell as! EditLocDetailTextCell
            textfields[c.detailTextField] = detail
            c.detailTextField.delegate = self
        case is EditLocDetailWithSliderCell:
            sliders[(cell as! EditLocDetailWithSliderCell).slider] = detail
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension LocationDetailsViewController: UITextFieldDelegate, KeyboardHandler {
    var handler: UIViewController? {
        return self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text! as NSString).replacingCharacters(in: range, with: string))
        let detail = textfields[textField]!
        switch detail {
        case .name:
            location?.name = text
        default:
            return false
        }
        editSaveButton.isEnabled = validate(textfield: textField)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func validate(textfield: UITextField) -> Bool {
        guard let detail = textfields[textfield] else {return false}
        switch detail {
        case LocationDetail.name:
            return !(location?.name.isEmpty ?? true)
        default:
            return true
        }
    }
}

