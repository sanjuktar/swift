//
//  TimeMO+CoreDataProperties.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/18/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension TimeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeMO> {
        return NSFetchRequest<TimeMO>(entityName: "TimeMO")
    }


}
