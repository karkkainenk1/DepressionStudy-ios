//
//  firstLaunch.swift
//  Health
//
//  Created by Admin on 7/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AWAREFramework

class firstLaunch: UIViewController {
    // NSDefault (boolean check for first launch)
    let hasLaunchedKey = "HasLaunched"              // string key for boolean
    let userDef = UserDefaults.standard             // userdefault class (has different default types)
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey) // sets key to false if no value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
