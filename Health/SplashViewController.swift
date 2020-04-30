//
//  splashViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/24/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  This file is for the detection of first installation of the application

import UIKit

class SplashViewController: UIViewController{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let appdelegate = UIApplication.shared.delegate! as! AppDelegate

            if (!appdelegate.hasLaunched()){
                self.toOnboarding()
            } else {
                self.toStudy()
            }
        }
    }
    
    
    // MARK: Unwind segues
    
    @IBAction func unwindToStudy(_ segue: UIStoryboardSegue) {
        toStudy()
    }
    
    // MARK: Transitions

    func toOnboarding() {
        performSegue(withIdentifier: "firstLaunch", sender: self)
    }
    
    func toStudy() {
        performSegue(withIdentifier: "launchedBefore", sender: self)
    }
}
