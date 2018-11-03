//
//  TaskMO+CoreDataClass.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TaskMO)
public class TaskMO: NSManagedObject {
    convenience init(from obj: Task, with context :NSManagedObjectContext) {
        self.init(context :context)
        copy(from: obj)
    }
    
    func copy(from obj :Task) {
        name = obj.name
        priority = obj.priority.description
        status = obj.status.description
        frequency = obj.frequency.description
        when = obj.when.managedObj(withContext: managedObjectContext!)
        desc = obj.description
    }
    
    func copy(to obj :Task) {
        obj.name = name!
        obj.priority = Task.Priority(rawValue: priority!)!
        obj.status = Task.Status(rawValue: status!)!
        obj.frequency = Task.Frequency(rawValue: frequency!)!
        obj.when = (when?.time)!
        obj.description = desc!
    }
}

extension Task {
    func managedObj(context :NSManagedObjectContext) -> TaskMO {
        let mo = TaskMO(context: context)
        mo.copy(from: self)
        return mo
    }
    
    convenience init(_ managedObj :TaskMO) {
        self.init("")
        managedObj.copy(to: self)
    }
}
