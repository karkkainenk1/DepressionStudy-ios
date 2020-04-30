//
//  AppDelegate.swift
//  Health
//
//  Created by Arthur Lobins on 7/2/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  Helpful Source: "https://github.com/tetujin/AWAREFramework-iOS"

import UIKit
import ResearchKit
import AWAREFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    public let studyURL = "https://api.awareframework.com/index.php/webservice/index/1953/BEkoVZ8H7lkf"
    
    let firstKey = "HasLaunched"
    
    public func hasLaunched() -> Bool {
        return UserDefaults.standard.bool(forKey: firstKey)
    }
    
    public func setHasLaunched(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: firstKey)
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        window?.tintColor = .purple
        if hasLaunched() {
            let study = AWAREStudy.shared()
            study.setDebug(true)
            let manager = AWARESensorManager.shared()
            manager.addSensors(with: study)
            manager.setDebugToAllSensors(true)
            manager.setDebugToAllStorage(true)
            manager.startAllSensors()
            manager.startAutoSyncTimer()
        }
        
        
        return true
    }
}

