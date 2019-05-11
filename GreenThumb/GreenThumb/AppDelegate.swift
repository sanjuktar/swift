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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.current = self
        do {
            seasons = try Season.Manager.load()
        } catch {
            seasons = Season.Manager()
            do {
                try seasons!.add(Season.allYear)
            } catch {
                seasons?.log?.output(.error, "Unable to add \"(Season.allYear.name)\" to \(seasons!.name)")
            }
        }
        do {
            locations = try Location.Manager.load()
        } catch {
            locations = Location.Manager()
            do {
                try locations!.add(Location.unknownLocation)
            } catch {
                locations!.log?.output(.error, "Unable to add \"\(Location.unknownLocation.name)\" to \(locations!.name)")
            }
        }
        do {
            actions = try ActionManager.load()
        } catch {
            actions = ActionManager()
        }
        do {
            care = try CareInstructions.Manager.load()
        } catch {
            care = CareInstructions.Manager()
        }
        do {
            plants = try Plant.Manager.load()
        } catch {
            plants = Plant.Manager()
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

