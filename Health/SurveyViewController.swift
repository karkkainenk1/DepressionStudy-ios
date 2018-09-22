//
//  ViewController.swift
//  Health
//
//  Created by Arthur Lobins on 7/2/18.
//  Copyright © 2018 Arthur Lobins. All rights reserved.
//  The main file of the background sensing

// ** Create a shared singleton for whole app between files:
// use struct to do this.

import UIKit
//import AWAREFramework

class SurveyViewController: UIViewController {
    // sets singleton firstKey's bool value to false
    let firstKey = "first"
    let userDef = UserDefaults.standard
    lazy var firstLaunched = userDef.bool(forKey: firstKey)
    // uses key from splashViewController.swift
    let hasLaunchedKey = "HasLaunched"
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey)
    @IBOutlet weak var hasAnsweredLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as? AWAREDelegate
    let core: AWARECore?
    let manager: AWARESensorManager?
    let study: AWAREStudy?
    let deviceId: String?
    
    required init?(coder aDecoder: NSCoder) {
        core = delegate?.sharedAWARECore
        manager = core?.sharedSensorManager
        study = core?.sharedAwareStudy
        deviceId = study?.getDeviceId()
        
        super.init(coder: aDecoder)
    }
    
    // start of main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!self.firstLaunched){
            self.startSubjectID()
            self.userDef.set(true, forKey: self.firstKey)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hasAnsweredLabel.isHidden = !hasAnsweredToday()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func radioButtons(radioNum: Int, radioTitle: String, radioInstr: String, radioAns: [String], sch: ESMSchedule) {
        //generic radio button creation function
        let str1 = String(radioNum) + "_radio"
        let str2 = "[" + String(radioNum) + radioTitle
        
        
        let esm = SingleESMObject.getEsmDictionaryAsRadio(withDeviceId: deviceId,
                                                          timestamp: NSDate.init().timeIntervalSince1970,
                                                          title: str2,
                                                          instructions: radioInstr,
                                                          submit: "Next",
                                                          expirationThreshold: 0,
                                                          trigger: str1,
                                                          radios: radioAns)
            as NSDictionary? as! [AnyHashable : Any]
        
        sch.addESM(esm)
    }
    
    @IBAction func dailyESMPressed(_ sender: Any) {
        // base code from github
        let schdule = ESMSchedule.init()
        schdule.title = "eWellness"
        schdule.body = "Please fill the daily questionnaire"
        schdule.identifier = "Daily Questionnaire"
        schdule.expiration = 0
        schdule.startDate = Date.init()
        schdule.endDate = Date.init(timeIntervalSinceNow: 7*60*60*24*10)
        schdule.fireHours = [0,9,15,21]
        
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
        
        let radioLast = SingleESMObject.getEsmDictionaryAsRadio(withDeviceId: deviceId,
                                                                timestamp: NSDate.init().timeIntervalSince1970,
                                                                title: "[10 of 10] During the PAST DAY, about how often did you feel ...",
                                                                instructions: "... worthless?",
                                                                submit: "Submit",
                                                                expirationThreshold: 0,
                                                                trigger: "10_radio",
                                                                radios: ans)
                    as NSDictionary? as! [AnyHashable : Any]
        
        schdule.addESM(radioLast)
        startESM(schedule: schdule, allowClose: true)
    }
    
    func startSubjectID() {
        let schdule = ESMSchedule.init()
        schdule.title = "eWellness"
        schdule.body = "Please enter the subject ID"
        schdule.identifier = "Subject ID"
        schdule.expiration = 0
        schdule.startDate = Date.init()
        schdule.endDate = Date.init(timeIntervalSinceNow: 7*60*60*24*10)
        schdule.fireHours = [0,9,15,21]
        
        let esm = SingleESMObject.getEsmDictionaryAsFreeText(withDeviceId: deviceId,
                                                             timestamp: NSDate.init().timeIntervalSince1970,
                                                             title: "Study ID",
                                                             instructions: "Enter your unique ID here:",
                                                             submit: "Submit",
                                                             expirationThreshold: 0,
                                                             trigger: "studyid")
            as NSDictionary? as! [AnyHashable : Any]
        
        schdule.addESM(esm)
        startESM(schedule: schdule, allowClose: false)
    }
    
    func startESM(schedule: ESMSchedule, allowClose: Bool) {
        schedule.interface = 1
        
        let iOSESM = IOSESM.init(awareStudy: study, dbType: AwareDBTypeCoreData)
        iOSESM?.setScheduled(schedule)
        
        let esmViewController = IOSESMScrollViewController.init()
        let naviController = UINavigationController.init(rootViewController: esmViewController)
        
        if allowClose {
            esmViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissESM))
        }
        
        self.present(naviController, animated: true) {}
    }
    
    @objc
    func dismissESM(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    func hasAnsweredToday() -> Bool {
        if let ctx = delegate?.managedObjectContext {
            let req = NSFetchRequest<NSFetchRequestResult>.init()
            req.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityESMAnswer.self), in: ctx)
            
            let sort = NSSortDescriptor.init(key: "timestamp", ascending: false)
            req.sortDescriptors = [sort]
            let resultsController = NSFetchedResultsController.init(fetchRequest: req, managedObjectContext: ctx, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try resultsController.performFetch()
                let results = resultsController.fetchedObjects
                
                if let results = results {
                    if results.count < 10 {
                        return false
                    }
                    
                    if let answer = results.last as? EntityESMAnswer {
                        let calendar = NSCalendar.current
                        let latestDate = Date.init(timeIntervalSince1970: TimeInterval(Int(answer.timestamp!) / 1000))
                        return calendar.isDateInToday(latestDate)
                    }
                }
                
            } catch {
                print("Exception thrown when trying to get latest ESM answers")
            }
            
        }
        return false
    }
}

