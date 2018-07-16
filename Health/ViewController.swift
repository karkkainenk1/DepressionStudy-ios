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
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet var subjectName: UILabel!
    @IBOutlet var subjectID: UITextField!
    @IBAction func submitID(_ sender: UIButton) {
        subjectName.text = subjectID.text
        subjectID.text = ""
        welcome.text = "Welcome"
        welcome.textAlignment = .center
        subjectName.textAlignment = .center
    }
    
    @IBAction func TestESM(_ sender: UIButton) {
        startESM()
        //viewDidAppear()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        let core = AWARECore.shared()
        let study = AWAREStudy.shared()
        let manager = AWARESensorManager.shared()
        core?.requestPermissionForBackgroundSensing()
        core?.requestPermissionForPushNotification()
        let url = "https://api.awareframework.com/index.php/webservice/index/1881/EEHEVhZ94rRJ"
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
        
        // Setting up sensors & syncing them to database on api.AwareFramework.com
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
       /* manager?.add(noise)
        manager?.add(conversation)
        manager?.add(battery)
        manager?.add(calls)
        manager?.add(iosESM)
        manager?.add(lin_acc)
        manager?.add(location)
        manager?.add(screen)
        manager?.add(time)*/
        
        // join ongoing study and start sensors with debugging option
        study?.join(withURL: url, completion: { (settings, studyState, error) in
            manager?.createDBTablesOnAwareServer()
            manager?.addSensors(with: study)
            manager?.setDebugToAllSensors(true)
            manager?.startAllSensors()
            
        })
        study?.setDebug(true)
        manager?.syncAllSensors()
        // data saved into sub-thread?
        // data saved into main-thread?
        // no data inside of sequel pro or on the awarestudy website
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        for n in 8...24 {
            schdule.addHour(NSNumber(value: n))
        }
     
        let radio1 = ESMItem.init(asRadioESMWithTrigger: "1_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio1?.setTitle("[1 of 10] During the past day, about how often did you feel ...")
        radio1?.setInstructions("... tired out for no good reason?")
        radio1?.setExpirationWithMinute(5)
        radio1?.setSubmitButtonName("Next")
        schdule.addESM(radio1)
        
        let radio2 = ESMItem.init(asRadioESMWithTrigger: "2_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio2?.setTitle("[2 of 10] During the past day, about how often did you feel ...")
        radio2?.setInstructions("... nervous?")
        radio2?.setExpirationWithMinute(5)
        radio2?.setSubmitButtonName("Next")
        schdule.addESM(radio2)

        let radio3 = ESMItem.init(asRadioESMWithTrigger: "3_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio3?.setTitle("[3 of 10] During the past day, about how often did you feel ...")
        radio3?.setInstructions("... so nervous that nothing could calm you down?")
        radio3?.setExpirationWithMinute(5)
        radio3?.setSubmitButtonName("Next")
        schdule.addESM(radio3)

        let radio4 = ESMItem.init(asRadioESMWithTrigger: "4_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio4?.setTitle("[4 of 10] During the past day, about how often did you feel ...")
        radio4?.setInstructions("... hopeless?")
        radio4?.setExpirationWithMinute(5)
        radio4?.setSubmitButtonName("Next")
        schdule.addESM(radio4)
        
        let radio5 = ESMItem.init(asRadioESMWithTrigger: "5_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio5?.setTitle("[5 of 10] During the past day, about how often did you feel ...")
        radio5?.setInstructions("... restless or fidgety?")
        radio5?.setExpirationWithMinute(5)
        radio5?.setSubmitButtonName("Next")
        schdule.addESM(radio5)
        
        let radio6 = ESMItem.init(asRadioESMWithTrigger: "6_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio6?.setTitle("[6 of 10] During the past day, about how often did you feel ...")
        radio6?.setInstructions("... so restless that you could not sit still?")
        radio6?.setExpirationWithMinute(5)
        radio6?.setSubmitButtonName("Next")
        schdule.addESM(radio6)
        
        let radio7 = ESMItem.init(asRadioESMWithTrigger: "7_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio7?.setTitle("[7 of 10] During the past day, about how often did you feel ...")
        radio7?.setInstructions("... depressed?")
        radio7?.setExpirationWithMinute(5)
        radio7?.setSubmitButtonName("Next")
        schdule.addESM(radio7)
        
        let radio8 = ESMItem.init(asRadioESMWithTrigger: "8_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio8?.setTitle("[8 of 10] During the past day, about how often did you feel ...")
        radio8?.setInstructions("... so depressed that nothing could cheer you up?")
        radio8?.setExpirationWithMinute(5)
        radio8?.setSubmitButtonName("Next")
        schdule.addESM(radio8)
        
        let radio9 = ESMItem.init(asRadioESMWithTrigger: "9_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio9?.setTitle("[9 of 10] During the past day, about how often did you feel ...")
        radio9?.setInstructions("... that everything was an effort?")
        radio9?.setExpirationWithMinute(5)
        radio9?.setSubmitButtonName("Next")
        schdule.addESM(radio9)
        
        let radio10 = ESMItem.init(asRadioESMWithTrigger: "10_radio", radioItems: ["None of the time", "A little of the time","Some of the time","Most of the time","All of the time"])
        radio10?.setTitle("[10 of 10] During the past day, about how often did you feel ...")
        radio10?.setInstructions("... worthless?")
        radio10?.setExpirationWithMinute(5)
        radio10?.setSubmitButtonName("Next")
        schdule.addESM(radio10)
 
        
        let esmManager = ESMScheduleManager.shared()
        // esmManager.removeAllNotifications()
        // esmManager.removeAllESMHitoryFromDB()
        // esmManager.removeAllSchedulesFromDB()
        esmManager?.add(schdule)
        
        let schedules = esmManager?.getValidSchedules()
        if let unwrappedSchedules = schedules {
            if(unwrappedSchedules.count > 0){
                let esmViewController = ESMScrollViewController.init()
                self.present(esmViewController, animated: true) {
                }
            }
        }
        
        
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
}

