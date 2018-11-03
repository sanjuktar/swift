//
//  SettingsViewController.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 8/17/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Section : String {
        case units = "Measurement units"
        case targets = "Trip targets"
        case generic = "Other settings"
        
        static var cases: [Section] = [.units, .targets, .generic]
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        if segue.identifier == "editSettingToSettingsSegue" {
            let editVC = segue.source as! EditValueViewController
            editVC.save()
            if editVC.currentChildVC is OptionsTableViewController {
                saveSettingFromOptionsTable(editVC.optionsTableVC)
            }
            else if editVC.currentChildVC is TextEditViewController {
                saveSettingFromTextEdit(editVC.textEditVC, ignore: editVC.ignoreStatus == .ignore(true))
            }
            tableView.reloadRows(at: [tableView.indexPathForSelectedRow!], with: .none)
        }
    }
    
    var selectedSetting: SettingController {
        return getSetting(tableView.indexPathForSelectedRow!)
    }
    
    var selectedSection: Section {
        return Section.cases[(tableView.indexPathForSelectedRow?.section)!]
    }
    
    var selectedRow: Int {
        return (tableView.indexPathForSelectedRow?.row)!
    }
    
    static let category = "Settings"
    var log = Log(category)
    var output :Output?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.titleView?.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsListToEditSettingSegue" {
            let dest = segue.destination as! EditValueViewController
            let setting = selectedSetting
            switch selectedSection {
            case .units:
                dest.valueName = "\(setting.name) Units"
                dest.ignoreStatus = .cannotIgnore
            case .targets:
                dest.valueName = "Target \(setting.name)"
                dest.ignoreStatus = (setting as! TargetSetting).ignore((Settings.current?.tripTemplate)!)
            default:
                dest.valueName = setting.name
            }
            dest.editType = setting.editType
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.cases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.cases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.cases[section] {
        case .units: return UnitsSetting.cases.count
        case .targets: return TargetSetting.cases.count
        case .generic: return GenericSetting.cases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var label = ""
        var details = ""
        switch Section.cases[indexPath.section] {
        case .units:
            let unit = UnitsSetting.cases[row]
            label = unit.rawValue
            details = unit.data
        case .targets:
            let metric = TargetSetting.cases[row]
            label = metric.rawValue
            details = metric.data(TripTemplate.current!)
        case .generic:
            let setting = GenericSetting.cases[row]
            label = setting.rawValue
            details = setting.data
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableCell")
        cell?.textLabel?.text = label + ":"
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.detailTextLabel?.text = details
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func saveSettingFromOptionsTable(_ editVC: OptionsTableViewController) {
        switch selectedSection {
        case .units:
            var setting = selectedSetting as! UnitsSetting
            guard case .optionsTable(let opts, _) = setting.editType else {return}
            let unit = opts[editVC.selected!]
            switch setting {
            case .pace:
                setting.currentUnit = unit as! SpeedUnit
            case .distance:
                setting.currentUnit  = unit as! DistanceUnit
            case .duration:
                setting.currentUnit = unit as! TimeUnit
            case .altitude:
                setting.currentUnit = unit as! DistanceUnit
            }
        case .targets:
            break
        case .generic:
            break
        }
    }
    
    func saveSettingFromTextEdit(_ editVC: TextEditViewController, ignore: Bool) {
        switch selectedSection {
        case .units:
            break
        case .targets:
            let target = Settings.current?.tripTemplate
            let setting = selectedSetting as! TargetSetting
            let ignorableDouble = ignore ? TripTemplate.ignore : Double(editVC.text!)!
            switch setting {
            case .distance:
                target?.distance = ignorableDouble
            case .pace:
                target?.pace = ignorableDouble
            case .duration:
                target?.duration = ignorableDouble
            case .distaceTolerance:
                target?.distanceTolerance = ignorableDouble
            case .paceTolerance:
                target?.paceTolerance = ignorableDouble
            case .durationTolerance:
                target?.durationTolerance = ignorableDouble
            }
        case .generic:
            let setting = selectedSetting as! GenericSetting
            switch setting {
            case .numSavedTrips:
                Settings.current?.numSavedTrips = Int(editVC.text!)!
            }
        }
    }
    
    func getSetting(_ indexPath: IndexPath) -> SettingController {
        let row = indexPath.row
        switch Section.cases[indexPath.section] {
        case .units:
            return UnitsSetting.cases[row]
        case .targets:
            return TargetSetting.cases[row]
        case .generic:
            return GenericSetting.cases[row]
        }
    }
}

