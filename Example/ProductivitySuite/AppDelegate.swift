//
//  AppDelegate.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 01/12/2017.
//  Copyright (c) 2017 Walter Vargas-Pena. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])        

        return true
        
    }

}
