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
    var locations: Location.Manager?
    var plants: Plant.Manager?
    var seasons: Season.Manager?
    var care: CareInstructions.Manager?
    var actions: ActionManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.current = self
        do {
            locations = try Location.Manager.load()
        } catch {
            locations = Location.Manager.create(addUnknownLocation: false)
            do {
                try locations?.add(Location.unknownLocation)
            } catch {
                log?.out(.error, "Unable to add \(Location.unknownLocation.name) to \(locations?.name)")
            }
        }
        do {
            plants = try Plant.Manager.load()
        } catch {
            plants = Plant.Manager()
        }
        do {
            seasons = try Season.Manager.load()
        } catch {
            seasons = Season.Manager()
        }
        do {
            care = try CareInstructions.Manager.load()
        } catch {
            care = CareInstructions.Manager()
        }
        do {
            actions = try ActionManager.load() 
        } catch {
            actions = ActionManager()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

