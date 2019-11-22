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
        setupAppearance()
        setupSeasons()
        setupLocations()
        setupActions()
        setupCare()
        setupPlants()
        return true
    }
    
    func setupAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = ColorConstants.NavigationBar.background
        appearance.barTintColor = ColorConstants.NavigationBar.buttonText
        //appearance.titleTextAttributes = []
    }
    
    func setupSeasons() {
        do {
            Season.manager = try Season.Manager.load()
        } catch {
            log?.out(.error, "Unable to load seasons list: \(error.localizedDescription). Using defaults.")
            Season.manager = Season.Manager()
            var season: Season? = AllYear.obj
            do {
                try Season.manager!.add(season!)
            } catch {
                log?.out(.error, "Unable to add \(AllYear.obj.name) to \(Season.manager!): \(error.localizedDescription)")
            }
            season = RestOfTheYear.obj
            do {
                try Season.manager!.add(season!)
            } catch {
                log?.out(.error, "Unable to add \(RestOfTheYear.obj.name)) to \(Season.manager!): \(error.localizedDescription)")
            }
            do {
                try Season.manager!.commit()
            } catch {
                log?.out(.error, "Unable to store default seasons list to be used later.")
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
        }
        if Location.manager?.get(UnknownLocation.obj.id) == nil {
            do {
                try Location.manager?.add(UnknownLocation.obj)
            } catch {
                log!.out(.error, "Error adding \(UnknownLocation.obj.name) to \(Location.manager): \(error.localizedDescription)")
            }
        }
        Defaults.initLocations()
    }
    
    func setupActions() {
    }
    
    func setupCare() {
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

