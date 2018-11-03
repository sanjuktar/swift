//
//  TaskList.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Tasklist : UIDocument {
    var list = [Task]()
    
    convenience init() {
        self.init(fileURL: URL(fileURLWithPath: ""))
        list = [Task]()
    }
    
    convenience init(withNames names :[String], withPriority priority:Task.Priority = .medium) {
        self.init()
        for name in names {
            list.append(Task(name, priority: priority, status: .new))
        }
    }
    
    convenience init(fromTasks tasks :[Task] = []) {
        self.init()
        list = tasks
    }
    
    func add(_ task :Task) {
        list.append(task)
    }
    
    func get(at indx :Int) -> Task {
        return (list[indx])
    }
    
    func set(at indx :Int, task :Task) {
        list[indx] = task
    }
    
    func remove(at indx :Int) {
        list.remove(at: indx)
    }
}
