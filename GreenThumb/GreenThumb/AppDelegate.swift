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
    var log: Log? = Log("GreenThumb")
    var window: UIWindow?
    var docs: Documents? = Documents()
    var cache: Cache?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.current = self
        Defaults.create()
        setupAppearance()
        Season.Manager.setup()
        Location.Manager.setup()
        setupActions()
        setupCare()
        Plant.Manager.setup()
        return true
    }
    
    func setupAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = ColorConstants.NavigationBar.background
        appearance.barTintColor = ColorConstants.NavigationBar.buttonText
        //appearance.titleTextAttributes = []
    }
    
    func setupActions() {
    }
    
    func setupCare() {
        Defaults.initCare()
    }
}

