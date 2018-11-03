//
//  TaskViewController.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/26/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class TaskViewController : UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var task :Task?
    
    override func viewDidLoad() {
        if task?.status == .new {
            task?.status = .seen
        }
        nameLabel.text = task?.name
        priorityLabel.text = task?.priority.rawValue
        priorityLabel.textColor = UIColor.from(priority: (task?.priority)!)
        statusLabel.text = task?.status.rawValue
        statusLabel.textColor = UIColor.from(status: (task?.status)!)
        freqLabel.text = task?.frequency.rawValue
        deadlineLabel.text = (task?.deadline == Date.distantFuture ? "none" : "deadline")
        descLabel.text = task?.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskDetailsToTaskEditSegue" {
            (segue.destination as! EditTaskViewController).task = Task(copyFrom: task!)
            //print("Task: \((segue.destination as! EditTaskViewController).task?.name)")
        }
    }
}
