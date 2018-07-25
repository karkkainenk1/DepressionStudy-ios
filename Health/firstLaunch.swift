//
//  firstLaunch.swift
//  Health
//
//  Created by Admin on 7/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class firstLaunch: UIViewController {
    @IBAction func startStudy(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startStudy", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

