//
//  DateMO+CoreDataProperties.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension DateMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateMO> {
        return NSFetchRequest<DateMO>(entityName: "DateMO")
    }

    @NSManaged public var date: NSDate?

}
