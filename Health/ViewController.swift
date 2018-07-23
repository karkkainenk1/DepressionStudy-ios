//
//  ViewController.swift
//  Health
//
//  Created by Admin on 7/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AWAREFramework

class ViewController: UIViewController {
    // NSDefault (boolean check for first launch)
    let hasLaunchedKey = "HasLaunched"              // string key for boolean
    let userDef = UserDefaults.standard             // userdefault class (has different default types)
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey) // sets key to false if no value
    
    // test buttons for interface
    @IBAction func TestESM(_ sender: UIButton) {
        startESM()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializing SensorManager, Study, and Core
        let core = AWARECore.shared()
        let study = AWAREStudy.shared()
        let manager = AWARESensorManager.shared()
        
        // Prompt user for notification and background sensing (Required for app)
        core?.requestPermissionForBackgroundSensing()
        core?.requestPermissionForPushNotification()
        
        // URL for study on AWAREFramework
        let url = "https://api.awareframework.com/index.php/webservice/index/1881/EEHEVhZ94rRJ"
        //let url = "https://api.awareframework.com/index.php/webservice/index/1893/8r5QnY0m2YAy" //only for ESM test
        study?.setStudyURL(url)
        
        // initialize sensors in DB
        let noise = AmbientNoise(awareStudy: study)
        let conversation = Conversation(awareStudy: study)
        let battery = Battery(awareStudy: study)
        let calls = Calls(awareStudy: study)
        let iosESM = IOSESM(awareStudy: study)
        let lin_acc = LinearAccelerometer(awareStudy: study)
        let location = Locations(awareStudy: study)
        let screen = Screen(awareStudy: study)
        let time = Timezone(awareStudy: study)
        
        // Starting sensors & syncing them to database on api.AwareFramework.com
        noise?.startSensor()
        noise?.startSyncDB()
        conversation?.startSensor()
        conversation?.startSyncDB()
        battery?.startSensor()
        battery?.startSyncDB()
        calls?.startSensor()
        calls?.startSyncDB()
        iosESM?.startSensor()
        iosESM?.startSyncDB()
        lin_acc?.startSensor()
        lin_acc?.startSyncDB()
        location?.startSensor()
        location?.startSyncDB()
        screen?.startSensor()
        screen?.startSyncDB()
        time?.startSensor()
        time?.startSyncDB()
        
        // join study and start sensors with debugging options
        study?.join(withURL: url, completion: { (settings, studyState, error) in
            manager?.createDBTablesOnAwareServer()
            manager?.addSensors(with: study)
            manager?.setDebugToAllSensors(true)
            manager?.startAllSensors()
        })
        study?.setDebug(true)
        manager?.syncAllSensors()
        // 5 second delay after seconds are activated
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if (!self.hasLaunched) {                                   // if application has not launched before,
                self.userDef.set(true, forKey: self.hasLaunchedKey)    // bool will always be true from here on out
                self.startSubjectID()                                  // prompt user for ID
            }
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewDidAppear() {
        // base code from github
        let esmManager = ESMScheduleManager.shared()
        let schedules = esmManager?.getValidSchedules()
        if let unwrappedSchedules = schedules {
            if(unwrappedSchedules.count > 0){
                let esmViewController = ESMScrollViewController.init()
                self.present(esmViewController, animated: true) {
                }
            }
        }
    }
    func startSubjectID() {
        // Create a FreeNumeric ESM that essentially accepts subject ID to store in DB
        let schedule = ESMSchedule.init()
        let text = ESMItem.init(asNumericESMWithTrigger: "ID")
        text?.setTitle("Study ID")
        text?.setInstructions("Enter your unique ID here:")
        text?.setExpirationWithMinute(10)
        text?.setSubmitButtonName("Submit")
        schedule.addESM(text)
        let esmManager = ESMScheduleManager.shared()
        
        // testing start (uncomment below when testing)
        esmManager?.removeAllNotifications()
        esmManager?.removeAllESMHitoryFromDB()
        esmManager?.removeAllSchedulesFromDB()
        // testing end (comment above when finished testing)
        
        esmManager?.add(schedule)
        // allows viewcontrol to display ESM
        viewDidAppear()
        
    }
 
    //generic radio creation function
    func radioButtons(radioNum: Int, radioInstr: String, sch: ESMSchedule) {
        let str1 = String(radioNum) + "_radio"
        let str2 = "[" + String(radioNum) + " of 10] During the past day, about how often did you feel ..."
        let radio = ESMItem.init(asRadioESMWithTrigger: str1, radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio?.setTitle(str2)
        radio?.setInstructions(radioInstr)
        radio?.setExpirationWithMinute(5)
        radio?.setSubmitButtonName("Next")
        sch.addESM(radio)
    }
    
    func startESM(){
        // base code from github
        let schdule = ESMSchedule.init()
        schdule.notificationTitle = "notification title"
        schdule.notificationBody = "notification body"
        schdule.scheduleId = "schedule_id"
        schdule.expirationThreshold = 60
        schdule.startDate = Date.init(timeIntervalSinceNow: -60*60*24*10)
        schdule.endDate = Date.init(timeIntervalSinceNow: 60*60*24*10)
        //schdule.fireHours = [12, 22]
        
        // testing start (uncomment below to test)
        for n in 8...23 {
            schdule.addHour(NSNumber(value: n))
        }
        // testing end (comment above if finished testing)
        
        // Radio button questions (10)
        radioButtons(radioNum: 1, radioInstr: "... tired out for no good reason?", sch: schdule)
        radioButtons(radioNum: 2, radioInstr: "... nervous?", sch: schdule)
        radioButtons(radioNum: 3, radioInstr: "... so nervous that nothing could calm you down?", sch: schdule)
        radioButtons(radioNum: 4, radioInstr: "... hopeless?", sch: schdule)
        radioButtons(radioNum: 5, radioInstr: "... restless or fidgety?", sch: schdule)
        radioButtons(radioNum: 6, radioInstr: "... so restless that you could not sit still?", sch: schdule)
        radioButtons(radioNum: 7, radioInstr: "... depressed?", sch: schdule)
        radioButtons(radioNum: 8, radioInstr: "... so depressed that nothing could cheer you up?", sch: schdule)
        radioButtons(radioNum: 9, radioInstr: "... that everything was an effort?", sch: schdule)
        radioButtons(radioNum: 10, radioInstr: "... worthless?", sch: schdule)
        let esmManager = ESMScheduleManager.shared()
        
        // testing start (uncomment below when testing)
        esmManager?.removeAllNotifications()
        esmManager?.removeAllESMHitoryFromDB()
        esmManager?.removeAllSchedulesFromDB()
        // testing end (comment above when finished testing)
        
        esmManager?.add(schdule)
        // allows viewcontrol to display ESM
        viewDidAppear()
    }
}

