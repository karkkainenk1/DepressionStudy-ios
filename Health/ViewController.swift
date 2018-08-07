//
//  ViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/2/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  The main file of the background sensing

import UIKit
import AWAREFramework

class ViewController: UIViewController {
    // sets singleton firstKey's bool value to false
    let firstKey = "first"
    let userDef = UserDefaults.standard
    lazy var firstLaunched = userDef.bool(forKey: firstKey)
    
    // Slide Menu Codes
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ubeView: UIView!
    var menuButtonIsVisible = false
    // Menu options are hidden behind ubeView and appear when menu button is pressed
    @IBAction func menuPressed(_sender: Any) {
        if !menuButtonIsVisible {
            leadingConstraint.constant = 150
            trailingConstraint.constant = -150
            menuButtonIsVisible = true
        }
        else {
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
            menuButtonIsVisible = false
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
    }

    // Tests
    @IBAction func TestESM2(_ sender: UIButton) {
        startWeeklyESM()
    }
    @IBAction func TestESM(_ sender: UIButton) {
        startDailyESM()
    }
    
    // start of main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let core = AWARECore.shared()
        let study = AWAREStudy.shared()
        let manager = AWARESensorManager.shared()
        
        // required for app to collect data
        core?.requestPermissionForBackgroundSensing()
        core?.requestPermissionForPushNotification()
        
        
        // AWAREFramework database (Need Author's E-Mail to access)
        let url = "https://api.awareframework.com/index.php/webservice/index/1910/cR0naPzp48ge"
        study?.setStudyURL(url)
        
        // initialize of sensors not automatically inferred from study
        let noise = AmbientNoise(awareStudy: study)
        let conversation = Conversation(awareStudy: study)
        manager?.add(noise)
        manager?.add(conversation)
        
        //let battery = Battery(awareStudy: study)
        //let calls = Calls(awareStudy: study)
        //let iosESM = IOSESM(awareStudy: study)
        //let lin_acc = LinearAccelerometer(awareStudy: study)
        //let location = Locations(awareStudy: study)
        //let screen = Screen(awareStudy: study)
        //let time = Timezone(awareStudy: study)
        // Starting sensors & syncing them to database on api.AwareFramework.com
        /* battery?.startSensor()
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
         time?.startSyncDB()*/
        
        // These codes connect to the study and starts sensors within in the url
        study?.join(withURL: url, completion: { (settings, studyState, error) in
            manager?.addSensors(with: study)
            manager?.createDBTablesOnAwareServer()
            manager?.setDebugToAllSensors(true)
            study?.setDebug(true)
            manager?.startAllSensors()
            manager?.syncAllSensors()
        })
        
        // Sync Interval (tentative)
        manager?.startAutoSyncTimer(withIntervalSecond: 20.0)
        
        // Delay 7 seconds (for sync) and prompts for ID iff the app is first installed
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            if (!self.firstLaunched){
                self.startSubjectID()
                self.userDef.set(true, forKey: self.firstKey)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewDidAppear() {
        // shows any ESM on screen
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
        // ESM for subject ID only (numberpad response)
        let schedule = ESMSchedule.init()
        let text = ESMItem.init(asNumericESMWithTrigger: "ID")
        text?.setTitle("Study ID")
        text?.setInstructions("Enter your unique ID here:")
        text?.setExpirationWithMinute(10)
        text?.setSubmitButtonName("Submit")
        schedule.addESM(text)
        let esmManager = ESMScheduleManager.shared()
        esmManager?.removeAllNotifications()
        esmManager?.removeAllESMHitoryFromDB()
        // Tentative code
        esmManager?.removeAllSchedulesFromDB()
        esmManager?.add(schedule)
        viewDidAppear()
    }
 
    
    func radioButtons(radioNum: Int, radioTitle: String, radioInstr: String, radioAns: [String], sch: ESMSchedule) {
        //generic radio button creation function
        let str1 = String(radioNum) + "_radio"
        let str2 = "[" + String(radioNum) + radioTitle
        let radio = ESMItem.init(asRadioESMWithTrigger: str1, radioItems: radioAns)
        radio?.setTitle(str2)
        radio?.setInstructions(radioInstr)
        radio?.setExpirationWithMinute(5)
        radio?.setSubmitButtonName("Next")
        sch.addESM(radio)
    }
    
    func startWeeklyESM(){
        // weekly ESM (tentative schedule)
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
        
        let ans1 = ["No difficulty", "A little difficulty", "Moderate difficulty","Quite a bit of difficulty","Extreme difficulty"]
        let ans2 = ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"]
        let ans3 = ["Never", "Rarely", "Sometimes", "Often", "Always"]
        let title1 = " of 24] During the PAST WEEK, how much difficulty did you have ..."
        let title2 = " of 24] During the PAST WEEK, how much of the time did you ..."
        let title3 = " of 24] During the PAST WEEK, how often did ..."
        // Radio button questions (24)
        radioButtons(radioNum: 1, radioTitle: title1, radioInstr: "... managing your day-to-day life?", radioAns: ans1, sch: schdule)
        radioButtons(radioNum: 2, radioTitle: title1, radioInstr: "... coping with problems in your life?", radioAns: ans1, sch: schdule)
        radioButtons(radioNum: 3, radioTitle: title1, radioInstr: "... concentrating?", radioAns: ans1, sch: schdule)
        radioButtons(radioNum: 4, radioTitle: title2, radioInstr: "... get along with people IN your family?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 5, radioTitle: title2, radioInstr: "... get along with people OUTSIDE of your family?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 6, radioTitle: title2, radioInstr: "... get along well in social situations?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 7, radioTitle: title2, radioInstr: "... feel close to another person?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 8, radioTitle: title2, radioInstr: "... feel like you had someone to turn to if you needed help?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 9, radioTitle: title2, radioInstr: "... feel confident in yourself?", radioAns: ans2,  sch: schdule)
        radioButtons(radioNum: 10, radioTitle: title2, radioInstr: "... feel sad or depressed?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 11, radioTitle: title2, radioInstr: "... think about ending your life?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 12, radioTitle: title2, radioInstr: "... feel nervous?", radioAns: ans2, sch: schdule)
        radioButtons(radioNum: 13, radioTitle: title3, radioInstr: "... you have thoughts racing through your head?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 14, radioTitle: title3, radioInstr: "... you think you had special powers?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 15, radioTitle: title3, radioInstr: "... you hear voices or see things?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 16, radioTitle: title3, radioInstr: "... you think people were watching you?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 17, radioTitle: title3, radioInstr: "... you think people were against you?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 18, radioTitle: title3, radioInstr: "... you have mood swings?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 19, radioTitle: title3, radioInstr: "... you feel short-tempered?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 20, radioTitle: title3, radioInstr: "... you think about hurting yourself?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 21, radioTitle: title3, radioInstr: "... you have an urge to drink alcohol or take street drugs?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 22, radioTitle: title3, radioInstr: "... anyone talk to you about your drinking or drug use?", radioAns: ans3, sch: schdule)
        radioButtons(radioNum: 23, radioTitle: title3, radioInstr: "... you try to hide your drinking or drug use?", radioAns: ans3, sch: schdule)
        // Last radio completed manually
        let radioLast = ESMItem.init(asRadioESMWithTrigger: "24_radio", radioItems: ans3)
        radioLast?.setTitle("[24 of 24] During the PAST WEEK, how often did ...")
        radioLast?.setInstructions("... you have problems from your drinking or drug use?")
        radioLast?.setExpirationWithMinute(5)
        radioLast?.setSubmitButtonName("Submit")
        schdule.addESM(radioLast)
        
        let esmManager = ESMScheduleManager.shared()
        
        esmManager?.removeAllNotifications()
        esmManager?.removeAllESMHitoryFromDB()
        // Tentative code
        esmManager?.removeAllSchedulesFromDB()
        
        esmManager?.add(schdule)
        // allows viewcontrol to display ESM
        viewDidAppear()
    }
    
    func startDailyESM(){
        // base code from github
        let schdule = ESMSchedule.init()
        schdule.notificationTitle = "notification title"
        schdule.notificationBody = "notification body"
        schdule.scheduleId = "schedule_id"
        schdule.expirationThreshold = 60
        schdule.startDate = Date.init(timeIntervalSinceNow: -60*60*24*10)
        schdule.endDate = Date.init(timeIntervalSinceNow: 60*60*24*10)
        // uncomment when adding schedule (fire hours are the (1-24) hour time slots)
        //schdule.fireHours = [12, 22]
        
        // testing start (uncomment below to test)
        for n in 8...23 {
            schdule.addHour(NSNumber(value: n))
        }
        // testing end (comment above if finished testing)
        let ans = ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"]
        let title = " of 10] During the PAST DAY, about how often did you feel ..."
        // Radio button questions (10)
        radioButtons(radioNum: 1, radioTitle: title, radioInstr: "... tired out for no good reason?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 2, radioTitle: title, radioInstr: "... nervous?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 3, radioTitle: title, radioInstr: "... so nervous that nothing could calm you down?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 4, radioTitle: title, radioInstr: "... hopeless?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 5, radioTitle: title, radioInstr: "... restless or fidgety?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 6, radioTitle: title, radioInstr: "... so restless that you could not sit still?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 7, radioTitle: title, radioInstr: "... depressed?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 8, radioTitle: title, radioInstr: "... so depressed that nothing could cheer you up?", radioAns: ans, sch: schdule)
        radioButtons(radioNum: 9, radioTitle: title, radioInstr: "... that everything was an effort?", radioAns: ans,  sch: schdule)
        // Last radio completed manually
        let radioLast = ESMItem.init(asRadioESMWithTrigger: "10_radio", radioItems: ans)
        radioLast?.setTitle("[10 of 10] During the PAST DAY, about how often did you feel ...")
        radioLast?.setInstructions("... worthless?")
        radioLast?.setExpirationWithMinute(5)
        radioLast?.setSubmitButtonName("Submit")
        schdule.addESM(radioLast)
        
        let esmManager = ESMScheduleManager.shared()

        esmManager?.removeAllNotifications()
        esmManager?.removeAllESMHitoryFromDB()
        // Tentative code
        esmManager?.removeAllSchedulesFromDB()

        esmManager?.add(schdule)
        // allows ESM to display
        viewDidAppear()
    }
}

