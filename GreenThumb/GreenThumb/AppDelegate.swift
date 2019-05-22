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
    var version: String = "0.1"
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
            log?.out(.error, "Unable to load seasons list: \(error.localizedDescription)")
            do {
                try seasons?.commit()
            } catch {
                log?.out(.error, "Unable to save new seasons manager.")
            }
            do {
                try seasons!.add(Season.allYear)
            } catch {
                seasons?.log?.output(.error, "Unable to add \"(Season.allYear.name)\" to \(seasons!.name): \(error.localizedDescription)")
            }
        }
        do {
            locations = try Location.Manager.load()
        } catch {
            locations = Location.Manager()
            locations?.log!.out(.error, "Unable to load list of locations: \(error.localizedDescription)")
            do {
                try locations?.commit()
            } catch {
                log?.out(.error, "Unable to save new locations manager.")
            }
            do {
                try locations!.add(Location.unknownLocation)
            } catch {
                locations!.log?.out(.error, "Unable to add \"\(Location.unknownLocation.name)\" to \(locations!.name)")
            }
        }
        do {
            actions = try ActionManager.load()
        } catch {
            actions = ActionManager()
            do {
                try actions?.commit()
            } catch {
                log?.out(.error, "Unable to save new actions manager.")
            }
            actions?.log?.out(.error, "Unable to load list of actions: \(error.localizedDescription)")
        }
        do {
            care = try CareInstructions.Manager.load()
        } catch {
            care = CareInstructions.Manager()
            do {
                try care?.commit()
            } catch {
                log?.out(.error, "Unable to save new care manager.")
            }
            care?.log?.out(.error, "Unable to load list of care instructions: \(error.localizedDescription)")
        }
        do {
            plants = try Plant.Manager.load()
        } catch {
            plants = Plant.Manager()
            do {
                try plants?.commit()
            } catch {
                log?.out(.error, "Unable to save new plants manager.")
            }
            plants?.log?.out(.error, "Unable to load list of plants: \(error.localizedDescription)")
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
        saveSnapshot()
    }
    
    private func saveSnapshot() {
        do {
            try seasons?.commit()
            log?.out(.info, "Saved list of seasons.")
        } catch {
            log?.out(.error, "Unable to save list of seasons: \(error.localizedDescription)")
        }
        do {
            try locations?.commit()
        } catch {
            log?.out(.error, "Unable to save locations list: \(error.localizedDescription)")
        }
        do {
            try actions?.commit()
        } catch {
            log?.out(.error, "Unable to save list of actions: \(error.localizedDescription)")
        }
        do {
            try care?.commit()
        } catch {
            log?.out(.error, "Unable to save list of care instructions: \(error.localizedDescription)")
        }
        do {
            try plants?.commit()
        } catch {
            log?.out(.error, "Unable to save plants list: \(error.localizedDescription)")
        }
        log!.out(.info, "Saved snapshot")
    }
}

