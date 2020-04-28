//
//  PermissionViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/24/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  This file is for the detection of first installation of the application

import UIKit
import AWAREFramework

class PermissionViewController: UIViewController{
    // sets singleton firstKey's bool value to false
    let hasLaunchedKey = "HasLaunched"
    let userDef = UserDefaults.standard
    
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Action will begin study and set singleton firstKey's bool to true
    @IBAction func startStudy(_ sender: UIButton) {
        self.agreeButton.isEnabled = false
        activityIndicator.startAnimating()
        

        let manager = AWARESensorManager.shared()
        let study   = AWAREStudy.shared()
        
        // AWAREFramework database (Need Author's E-Mail to access)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        study.setStudyURL(appDelegate!.studyURL)
        
        study.setDebug(false)
        manager.startAllSensors()
        manager.startAutoSyncTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            for sensor in (manager.getAllSensors()) {
                if sensor.getName() != nil {
                    print(sensor.getName()!)
                }
            }
            
            self.performSegue(withIdentifier: "startStudy", sender: self)
            self.userDef.set(true, forKey: self.hasLaunchedKey)
        })
    }
}
