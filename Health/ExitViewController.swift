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
import AWAREFramework

class ExitViewController: UIViewController {
    @IBOutlet weak var exitStudyButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // End study button
    @IBAction func exitButton(_ sender: UIButton) {
        let appdelegate = UIApplication.shared.delegate! as! AppDelegate
        
        if (appdelegate.hasLaunched()) {
            sender.setTitle("Thank you for your participation. Exiting study now...", for: .normal)
            activityIndicator.startAnimating()
            exitStudyButton.isEnabled = false
            // turn off sensors here
            // deactivate core
            let core = AWARECore.shared()
            let manager = AWARESensorManager.shared()
            manager.stopAndRemoveAllSensors()
            manager.stopAutoSyncTimer()
            core.deactivate()
            
            appdelegate.setHasLaunched(false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                exit(0)
            }
        }
    }
}

