//
//  CareDetailsViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class CareDetailsViewController: EditableTableViewController {
    @IBOutlet weak var detailsTable: UITableView!
    
    static var scheduleSegue = ""
    static var returnToListSegue = ""
    
    var care: CareInstructions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log = AppDelegate.current?.log
        table = detailsTable
        setEditMode(editMode)
        tableController = DetailsTableController<CareDetail>.setup(care!, self)
        textController = DetailTextFieldDelegate<CareDetail>(care!, self)
        editSaveButton?.isEnabled = CareDetail.validate(care!)
    }
    
    func season(_ item: CareType, _ pos: Int) -> UniqueId {
        return (care?.schedule[item]?.seasons[pos])!
    }
    
    func timetable(_ item: CareType, _ season: UniqueId) -> Timetable {
        return (care?.schedule[item]?.timetable[season])!
    }
}
