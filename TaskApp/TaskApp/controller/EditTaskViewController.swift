//
//  EditTaskViewController.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/27/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class EditTaskViewController : UITableViewController {
    
    var task :Task?
    
    override func viewDidLoad() {
        print("Task: \(task?.name)")
        //nameTextField.text = "blah"//task?.name
        //priorityTextField.text = task?.priority.rawValue
        //statusTextField.text = task?.status.rawValue
        //freqTextField.text = task?.frequency.rawValue
        //deadlineTextField.text = task?.deadline.description
        //descTextView.text = task?.description
    }
}
