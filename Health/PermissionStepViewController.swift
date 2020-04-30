//
//  PermissionStepViewController.swift
//  Health
//
//  Created by Tyler Davis on 4/30/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import ResearchKit

class PermissionDataStepViewController: ORKInstructionStepViewController {
    // MARK: Properties
    
    var permissionStep: PermissionStep? {
        return step as? PermissionStep
    }
    
    // MARK: ORKInstructionStepViewController
    
    override func goForward() {
        permissionStep?.startStudy() { succeeded, _ in
            // The second part of the guard condition allows the app to proceed on the Simulator (where health data is not available)
            guard succeeded || (TARGET_OS_SIMULATOR != 0) else { return }
            
            OperationQueue.main.addOperation {
                super.goForward()
            }
        }
    }
}
