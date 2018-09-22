//
//  ExitViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/2/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  The main file of the background sensing

// ** Create a shared singleton for whole app between files:
// use struct to do this.

import UIKit
//import AWAREFramework

class ExitViewController: UIViewController {
    // sets singleton firstKey's bool value to false
    let firstKey = "first"
    let userDef = UserDefaults.standard
    lazy var firstLaunched = userDef.bool(forKey: firstKey)
    // uses key from splashViewController.swift
    let hasLaunchedKey = "HasLaunched"
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey)
    
    @IBOutlet weak var exitStudyButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // End study button
    @IBAction func exitButton(_ sender: UIButton) {
        if (hasLaunched) {
            
            //sender.setTitle("Thank you for your participation. Exiting study now...", for: UIControlState.normal)
            activityIndicator.startAnimating()
            exitStudyButton.isEnabled = false
            // turn off sensors here
            // deactivate core
            let delegate = UIApplication.shared.delegate as? AWAREDelegate
            let core = delegate?.sharedAWARECore
            let manager = core?.sharedSensorManager
            //manager?.stopAllSensors()
            manager?.stopAndRemoveAllSensors()
            //manager?.stopAutoSyncTimer()
            manager?.stopUploadTimer()
            core?.deactivate()
            
            self.userDef.set(false, forKey: self.hasLaunchedKey)
            self.userDef.set(false, forKey: self.firstKey)
            self.userDef.synchronize()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                exit(0)
            }
        }
    }
}

