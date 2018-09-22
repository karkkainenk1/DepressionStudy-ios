//
//  splashViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/24/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  This file is for the detection of first installation of the application

import UIKit

class SplashViewController: UIViewController{
    // sets singleton firstKey's bool value to false
    let hasLaunchedKey = "HasLaunched"
    let userDef = UserDefaults.standard
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if (!self.hasLaunched){
                self.performSegue(withIdentifier: "firstLaunch", sender: self)
            } else {
                self.performSegue(withIdentifier: "launchedBefore", sender: self)
            }
        }
    }
}
