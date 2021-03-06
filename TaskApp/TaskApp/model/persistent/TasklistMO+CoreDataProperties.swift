//
//  TasklistMO+CoreDataProperties.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension TasklistMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TasklistMO> {
        return NSFetchRequest<TasklistMO>(entityName: "TasklistMO")
    }

    @NSManaged public var list: NSObject?
    @NSManaged public var name: String?

}
