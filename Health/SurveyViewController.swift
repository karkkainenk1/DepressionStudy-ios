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
import AWAREFramework

class SurveyViewController: UIViewController {
    @IBOutlet weak var hasAnsweredLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate
    let core: AWARECore?
    let manager: AWARESensorManager?
    let study: AWAREStudy?
    let deviceId: String?
    
    required init?(coder aDecoder: NSCoder) {
        core    = AWARECore.shared()
        manager = AWARESensorManager.shared()
        study   = AWAREStudy.shared()
        deviceId = study?.getDeviceId()
        
        super.init(coder: aDecoder)
    }
    
    // start of main
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = UIApplication.shared.delegate! as! AppDelegate
        if (!appdelegate.hasLaunched()){
            self.startSubjectID()
            appdelegate.setHasLaunched(true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    @objc
    func updateUI() {
        hasAnsweredLabel.isHidden = !hasAnsweredToday()
    }
    
    func radioButtons(radioNum: Int, radioTitle: String, radioInstr: String, radioAns: [String], sch: ESMSchedule) {
        //generic radio button creation function
        let str1 = String(radioNum) + "_radio"
        let str2 = "[" + String(radioNum) + radioTitle
        
        let esm = ESMItem.init(asRadioESMWithTrigger: str1, radioItems: radioAns)
        esm.setTitle(str2)
        esm.setInstructions(radioInstr)
        esm.setSubmitButtonName("Next")
        esm.setExpirationWithMinute(1440)
        
        sch.addESM(esm)
    }
    
    @IBAction func dailyESMPressed(_ sender: Any) {
        let schdule = ESMSchedule.init()
        schdule.notificationTitle = "eWellness"
        schdule.notificationBody = "Please fill the daily questionnaire"
        schdule.scheduleId = "Daily Questionnaire"
        schdule.expirationThreshold = 1440
        schdule.startDate = Date.init()
        schdule.endDate = Date.init(timeIntervalSinceNow: 7*60*60*24*10)
        schdule.fireHours = [-1]
        
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
        
        let radioLast = ESMItem.init(asRadioESMWithTrigger: "10_radio", radioItems: ans)
        radioLast.setTitle("[10 of 10] During the PAST DAY, about how often did you feel ...")
        radioLast.setInstructions("... worthless?")
        radioLast.setSubmitButtonName("Submit")
        radioLast.setExpirationWithMinute(1440)
        
        schdule.addESM(radioLast)
        startESM(schedule: schdule, allowClose: true)
    }
    
    func startSubjectID() {
        let schdule = ESMSchedule.init()
        schdule.notificationTitle = "eWellness"
        schdule.notificationBody = "Please enter the subject ID"
        schdule.scheduleId = "Subject ID"
        schdule.expirationThreshold = 525600
        schdule.startDate = Date.init()
        schdule.endDate = Date.init(timeIntervalSinceNow: 7*60*60*24*10)
        schdule.fireHours = [-1]
            
        let esm = ESMItem.init(asNumericESMWithTrigger: "studyid")
        esm.setTitle("Study ID")
        esm.setInstructions("Enter your unique ID here:")
        esm.setSubmitButtonName("Submit")
        esm.setExpirationWithMinute(525600)
        
        schdule.addESM(esm)
        startESM(schedule: schdule, allowClose: false)
    }
    
    func startESM(schedule: ESMSchedule, allowClose: Bool) {
        schedule.interface = 1
        
        let manager = ESMScheduleManager.shared()
        manager.debug = true
        manager.removeAllSchedulesFromDB()
        manager.add(schedule)
        
        let esmViewController = ESMScrollViewController.init()
        esmViewController.view.backgroundColor = .systemBackground
        let naviController = UINavigationController.init(rootViewController: esmViewController)
        
        if allowClose {
            esmViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissESM))
        }

        naviController.modalPresentationStyle = .fullScreen
        self.present(naviController, animated: true) { }
    }
    
    @objc
    func dismissESM(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    func hasAnsweredToday() -> Bool {
        if let context = CoreDataHandler.shared().managedObjectContext {
            context.persistentStoreCoordinator = CoreDataHandler.shared().persistentStoreCoordinator
            
            let req = NSFetchRequest<NSFetchRequestResult>.init()
            req.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityESMAnswer.self), in: context)
            
            let sort = NSSortDescriptor.init(key: "timestamp", ascending: false)
            req.sortDescriptors = [sort]
            let resultsController = NSFetchedResultsController.init(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try resultsController.performFetch()
                let results = resultsController.fetchedObjects
                
                if let results = results {
                    if results.count < 10 {
                        return false
                    }
                    
                    if let answer = results.last as? EntityESMAnswer {
                        let calendar = NSCalendar.current
                        let latestDate = Date.init(timeIntervalSince1970: TimeInterval(Int(truncating: answer.timestamp!) / 1000))
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

