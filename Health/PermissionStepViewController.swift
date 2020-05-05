//
//  PermissionStepViewController.swift
//  Health
//
//  Created by Tyler Davis on 4/30/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import ResearchKit

class PermissionDataStepViewController: ORKTableStepViewController {
  // MARK: Properties

  var permissionStep: PermissionStep? {
    return step as? PermissionStep
  }

  // MARK: ORKTableStepViewController

  override func goForward() {

    OperationQueue.main.addOperation { super.goForward() }
    if permissionStep?.startStudy() ?? false {
      OperationQueue.main.addOperation {
        super.goForward()
      }
    }
  }
}
