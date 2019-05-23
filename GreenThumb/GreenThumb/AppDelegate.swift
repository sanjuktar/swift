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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.current = self
        do {
            Season.manager = try Season.Manager.load()
        } catch {
            log?.out(.error, "Unable to load seasons list: \(error.localizedDescription)")
            Season.manager = Season.Manager()
            do {
                try Season.manager!.add(Season.allYear)
                
            } catch {
                log?.output(.error, "Unable to add \"(Season.allYear)\" to \(Season.manager!): \(error.localizedDescription)")
            }
        }
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
        do {
            Plant.manager = try Plant.Manager.load()
        } catch {
            Plant.manager = Plant.Manager()
            do {
                try Plant.manager?.commit()
            } catch {
                log?.out(.error, "Unable to save new plants manager.")
            }
            log?.out(.error, "Unable to load list of plants: \(error.localizedDescription)")
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
            try Season.manager?.commit()
            log?.out(.info, "Saved list of seasons.")
        } catch {
            log?.out(.error, "Unable to save list of seasons: \(error.localizedDescription)")
        }
        do {
            try Location.manager?.commit()
        } catch {
            log?.out(.error, "Unable to save locations list: \(error.localizedDescription)")
        }
        do {
            try Action.manager?.commit()
        } catch {
            log?.out(.error, "Unable to save list of actions: \(error.localizedDescription)")
        }
        do {
            try CareInstructions.manager?.commit()
        } catch {
            log?.out(.error, "Unable to save list of care instructions: \(error.localizedDescription)")
        }
        do {
            try Plant.manager?.commit()
        } catch {
            log?.out(.error, "Unable to save plants list: \(error.localizedDescription)")
        }
        log!.out(.info, "Saved snapshot")
    }
}

