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

class PermissionStep: ORKTableStep {
    // MARK: Initialization
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = "Data Permissions"
        text =
        """
        We’re about to ask you to allow a bunch of intrusive permissions for our app, so before we do, we wanted to explain precisely what information we will be collecting and how it will be used.

        Firstly, please note that we will NOT be collecting any personally identifiable information on you, including taking any photos, videos, or recording any conversations.

        Our application will also NOT conduct any activities other than collecting sensor data and survey responses.

        If you have any concerns about the data being collected please let us know. You will have to allow all permissions in order for the application to work properly.

        So here is precisely what sensors we will be collecting and how it will be used:
        """
        items = [
           "Communication: We’ll monitor a log of incoming and outgoing phone calls, including the number of phone calls. We won’t be storing specific contact info, just the quantity of social interactions. This does NOT assess or record the content of communications." as NSString,
           "Location: location calculated using GPS, cellular, and WiFi." as NSString,
            "Ambient sound detection: We will detect when your external environment is louder than 50 decibels using the phone’s microphone. We will only record decibel levels and NOT record any audio." as NSString,
            "Activity and movements: we will use the accelerometer, gyroscope, and GPS tracking to identify activities like biking and running." as NSString,
            "Light: We will use the phone’s light sensor to detect light levels associated with being outside or in a dark location." as NSString,
            "Phone use: We will monitor phone screen on-time." as NSString,
        ]

        bulletType = .circle
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Convenience
    
    func startStudy() -> Bool {
        let manager = AWARESensorManager.shared()
        let study   = AWAREStudy.shared()
        study.setDebug(false)
        // AWAREFramework database (Need Author's E-Mail to access)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        study.join(withURL: appDelegate!.studyURL, completion: { (_, _, error) in
            if error != nil {
                // #TODO: ERROR HANDLING
                print(error!)
                return
            }
            
            manager.addSensors(with: study)
            manager.setDebugToAllSensors(false)
            manager.setDebugToAllStorage(false)
            manager.startAllSensors()
            manager.startAutoSyncTimer()
            print("Sensors: ", manager.getAllSensors())
        })
        return true
    }
}
