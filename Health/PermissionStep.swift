//
//  PermissionStep.swift
//  Health
//
//  Created by Tyler Davis on 4/30/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import ResearchKit
import HealthKit
import AWAREFramework

class PermissionStep: ORKInstructionStep {
    // MARK: Initialization
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = NSLocalizedString("Health Data", comment: "")
        text = NSLocalizedString("On the next screen, you will be prompted to grant access to read and write some of your general and health information, such as height, weight, and steps taken so you don't have to enter it again.", comment: "")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Convenience
    
    func startStudy(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let manager = AWARESensorManager.shared()
        let study   = AWAREStudy.shared()
        study.setDebug(true)
        
        // AWAREFramework database (Need Author's E-Mail to access)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        study.join(withURL: appDelegate!.studyURL, completion: { (_, _, error) in
            if error != nil {
                // #TODO: ERROR HANDLING
                print(error!)
                return
            }
            
            manager.addSensors(with: study)
            manager.setDebugToAllSensors(true)
            manager.setDebugToAllStorage(true)
            manager.startAllSensors()
            manager.startAutoSyncTimer()
            print("Sensors: ", manager.getAllSensors())
        })
    }
}
