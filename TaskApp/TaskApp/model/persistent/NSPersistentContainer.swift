//
//  NSPersistentContainer.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 7/14/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    
    func load() {
        loadPersistentStores { storeDescription, error in
            self.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func commit() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
