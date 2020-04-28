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
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Action will begin study and set singleton firstKey's bool to true
    @IBAction func startStudy(_ sender: UIButton) {
        agreeButton.isEnabled = false
        activityIndicator.startAnimating()
        
        let manager = AWARESensorManager.shared()
        let study   = AWAREStudy.shared()
        study.setDebug(true)
        
        // AWAREFramework database (Need Author's E-Mail to access)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        study.join(withURL: appDelegate!.studyURL, completion: { (_, _, error) in
            if error != nil {
                // #TODO: ERROR HANDLING
                print(error!)
                self.agreeButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            manager.addSensors(with: study)
            manager.setDebugToAllSensors(true)
            manager.setDebugToAllStorage(true)
            manager.startAllSensors()
            manager.startAutoSyncTimer()
            print("Sensors: ", manager.getAllSensors())
            
            self.performSegue(withIdentifier: "startStudy", sender: self)
        })
    }
}
