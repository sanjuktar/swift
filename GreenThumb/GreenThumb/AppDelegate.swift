//
//  AppDelegate.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var current: AppDelegate?
    var window: UIWindow?
    var log: Log? = Log("GreenThumb")
    var docs: Documents? = Documents()
    var cache: Cache?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.current = self
        Defaults.create()
        setupSeasons()
        setupLocations()
        setupActions()
        setupCare()
        setupPlants()
        do {
           try Defaults.commit()
        } catch {
            log?.out(.error, "Unable to commit Defaults.")
        }
        return true
    }
    
    func setupSeasons() {
        do {
            Season.manager = try Season.Manager.load()
        } catch {
            log?.out(.error, "Unable to load seasons list: \(error.localizedDescription)")
            Season.manager = Season.Manager()
            let season = AllYear()
            Season.allYear = season.id
            do {
                try Season.manager!.add(season)
                
            } catch {
                log?.output(.error, "Unable to add \"(Season.allYear)\" to \(Season.manager!): \(error.localizedDescription)")
            }
        }
        Defaults.initSeasonal()
    }
    
    func setupLocations() {
        do {
            Location.manager = try Location.Manager.load()
        } catch {
            log!.out(.error, "Unable to load list of locations: \(error.localizedDescription)")
            Location.manager = Location.Manager()
            do {
                try Location.manager?.addUnknownLocation()
            } catch {
                log!.out(.error, "Error in creating locations: \(error.localizedDescription)")
            }
        }
        Defaults.initLocations()
    }
    
    func setupActions() {
        do {
            Action.manager = try ActionManager.load()
        } catch {
            Action.manager = ActionManager()
            do {
                try Action.manager?.commit()
            } catch {
                log?.out(.error, "Unable to save new actions manager.")
            }
            log?.out(.error, "Unable to load list of actions: \(error.localizedDescription)")
        }
    }
    
    func setupCare() {
        do {
            CareInstructions.manager = try CareInstructions.Manager.load()
        } catch {
            CareInstructions.manager = CareInstructions.Manager()
            do {
                try CareInstructions.manager?.commit()
            } catch {
                log?.out(.error, "Unable to save new care manager.")
            }
            log?.out(.error, "Unable to load list of care instructions: \(error.localizedDescription)")
        }
        Defaults.initCare()
    }
    
    func setupPlants() {
        do {
            Plant.manager = try Plant.Manager.load()
        } catch {
            log?.out(.error, "Unable to load list of plants: \(error.localizedDescription)")
            Plant.manager = Plant.Manager()
            do {
                try Plant.manager?.commit()
            } catch {
                log?.out(.error, "Unable to save new plants manager.")
            }
        }
    }
}

