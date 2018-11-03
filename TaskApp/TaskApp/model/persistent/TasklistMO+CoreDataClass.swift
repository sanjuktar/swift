//
//  TasklistMO+CoreDataClass.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TasklistMO)
public class TasklistMO: NSManagedObject {
    
    convenience init(from tasklist :Tasklist, with context :NSManagedObjectContext) {
        self.init(context: context)
        copy(from: tasklist)
    }
    
    func copy(to tasklist : Tasklist) {
        print("Tasklist \(name!)")
        tasklist.name = name!
        tasklist.list = (list as! [TaskMO]).map{Task($0)}
    }
    
    func copy(from tasklist :Tasklist) {
        name = tasklist.name
        var l :[TaskMO]
        if let lst = list as! [TaskMO]? {
            l = lst
            l.removeAll()
        }
        else {
            l = [TaskMO]()
        }
        tasklist.list?.forEach({task in l.append(TaskMO(from :task, with :managedObjectContext!))})
        list = l as? NSObject
    }
}
