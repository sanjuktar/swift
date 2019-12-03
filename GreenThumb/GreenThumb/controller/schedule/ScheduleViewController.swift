//
//  ScheduleViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ScheduleViewController: EditableTableViewController, TableController {
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var _editSaveButton: UIBarButtonItem!
    
    var schedule: SeasonalSchedule?
    var reuseIds: [String:String] = [
        "FrequencyBySeasonCell":ReuseId.frequencyBySeasonCell
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        log = AppDelegate.current?.log
        table = detailsTable
        table?.delegate = self
        table?.dataSource = self
        title = "Care Schedule"
        for cellType in reuseIds {
            table?.register(UINib(nibName: cellType.key, bundle: nil), forCellReuseIdentifier: cellType.value)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (schedule?.seasons.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return EditableTextCell.get(self, "Name:", schedule!.name, editMode: editMode)
        }
        let timetable = schedule!.timetable
        let season = Season.manager?.get((schedule?.seasons[indexPath.row-1]) ?? AllYear.id)
        var freq = timetable[season!.id]?.freq
        if freq == nil {
            if !editMode {
                return EditableTextCell.get(self, "Name:", "Unable to determine schedule.", editMode: editMode)
            }
            freq = ActionFrequency(nTimes: 0, timeUnitX: 0, timeUnit: .weeks)
        }
        return FrequencyBySeasonCell.get(self, season!, freq!.nTimes, freq!.timeUnitX, freq!.timeUnit, startDate: nil, endDate: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return DetailsConstants.Table.Cell.Height.detailCell
        }
        return 200
    }
}
