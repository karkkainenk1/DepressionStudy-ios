//
//  AppDelegate.swift
//  Health
//
//  Created by Arthur Lobins on 7/2/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  Helpful Source: "https://github.com/tetujin/AWAREFramework-iOS"

import UIKit
import AWAREFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    public let studyURL = "https://api.awareframework.com/index.php/webservice/index/1953/BEkoVZ8H7lkf"
    
    let firstKey = "first"
    let userDef = UserDefaults.standard
    lazy var firstLaunched = userDef.bool(forKey: firstKey)
    // uses key from splashViewController.swift
    let hasLaunchedKey = "HasLaunched"
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if firstLaunched {
            let study = AWAREStudy.shared()
            study.join(withURL: studyURL)
        }
        
        return true
    }
}

