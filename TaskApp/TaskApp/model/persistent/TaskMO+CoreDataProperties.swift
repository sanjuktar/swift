//
//  TaskMO+CoreDataProperties.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "TaskMO")
    }

    @NSManaged public var desc: String?
    @NSManaged public var frequency: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var when: TimeMO?

}
