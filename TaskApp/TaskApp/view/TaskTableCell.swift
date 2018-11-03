//
//  TaskTableCell.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class TaskTableCell : UITableViewCell {
    
    @IBAction func checkboxClicked(_ sender: Any) {
        if task?.status != .done {
            task?.status = .done
        }
        else {
            task?.status = .seen
        }
        checkboxButton.isChecked = (task?.status == .done)
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkboxButton: Checkbox!
    
    var task :Task?
    
    func reset(withTask task:Task) {
        self.task = task
        taskNameLabel.text = task.name
        taskNameLabel.textColor = UIColor.from(priority: task.priority)
        checkboxButton.isChecked = (task.status == .done)
        self.accessoryType = .disclosureIndicator
    }
}
