//
//  ScheduleViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/22/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class ScheduleViewController: EditableTableViewController {
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
        title = "Care Schedule"
        for cellType in reuseIds {
            table?.register(UINib(nibName: cellType.key, bundle: nil), forCellReuseIdentifier: cellType.value)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//schedule?.seasons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return EditableTextCell.get(self, "Name:", schedule!.name , editMode: editMode)
        }
        return FrequencyBySeasonCell.get(self, AllYear.obj, 1, 1, .weeks, startDate: nil, endDate: nil)
    }
}
