//
//  splashViewController.swift
//  Health
//
//  Created by Admin on 7/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class splashViewController: UIViewController{
    // NSDefault (boolean check for first launch)
    let hasLaunchedKey = "HasLaunched"              // string key for boolean
    let userDef = UserDefaults.standard             // userdefault class (has different default types)
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey) // sets key to false if no value
    
    @IBOutlet weak var tapToStart: UILabel!
    @IBAction func startStudy(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startStudy", sender: self)
        userDef.set(true, forKey: hasLaunchedKey)
    }
    @IBAction func NextViewController(_ sender: UIButton){
        tapToStart.text = "Loading ..."
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
