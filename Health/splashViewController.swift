//
//  splashViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/24/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  This file is for the detection of first installation of the application

import UIKit

class splashViewController: UIViewController{
    // sets singleton firstKey's bool value to false
    let hasLaunchedKey = "HasLaunched"
    let userDef = UserDefaults.standard
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey)
    
    @IBOutlet weak var tapToStart: UILabel!
    // Action will begin study and set singleton firstKey's bool to true
    @IBAction func startStudy(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startStudy", sender: self)
        // commented for testing
        //userDef.set(true, forKey: hasLaunchedKey)
    }
    @IBAction func NextViewController(_ sender: UIButton){
        tapToStart.text = "Loading ..."
        // Delay of 2 second, then determines if instance is first installation 
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if (!self.hasLaunched){
                self.performSegue(withIdentifier: "firstLaunch", sender: self)
            }
            else {
                self.performSegue(withIdentifier: "launchedBefore", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
