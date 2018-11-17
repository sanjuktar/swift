//
//  PlantsManager.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/14/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class PlantsManager: Codable {
    static var current = (UIApplication.shared.delegate as! AppDelegate).plantsManager
    static var log = (UIApplication.shared.delegate as! AppDelegate).log
    var idCount: Int = 0
    var preferedNameType: Plant.NameType = Plant.NameType.nickname
    
    static func newId() -> String {
        current?.idCount += 1
        do {
            try current?.commit()
        } catch {
            log?.out(.error, "Unable to store current state of PlantsManager: \(error.localizedDescription)")
        }
        return "Plant\(current!.idCount)"
    }
    
    static func load() throws -> PlantsManager {
        return try (Documents.instance?.retrieve("PlantsManager", as: PlantsManager.self))!
    }
    
    func commit() throws {
        try Documents.instance?.store(self, as: "PlantsManager")
    }
}
