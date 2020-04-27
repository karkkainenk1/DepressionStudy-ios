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
    // sets singleton firstKey's bool value to false
    let firstKey = "first"
    let userDef = UserDefaults.standard
    lazy var firstLaunched = userDef.bool(forKey: firstKey)
    // uses key from splashViewController.swift
    let hasLaunchedKey = "HasLaunched"
    lazy var hasLaunched = userDef.bool(forKey: hasLaunchedKey)
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
        
        
//        let esm = SingleESMObject.getEsmDictionaryAsRadio(withDeviceId: deviceId,
//                                                          timestamp: NSDate.init().timeIntervalSince1970,
//                                                          title: str2,
//                                                          instructions: radioInstr,
//                                                          submit: "Next",
//                                                          expirationThreshold: 0,
//                                                          trigger: str1,
//                                                          radios: radioAns)
//            as NSDictionary? as! [AnyHashable : Any]
        
        let esm = ESMItem.init(asRadioESMWithTrigger: str1, radioItems: radioAns)
        esm.setTitle(str2)
        esm.setInstructions(radioInstr)
        esm.setSubmitButtonName("Next")
        esm.setExpirationWithMinute(0)
        
        sch.addESM(esm)
    }
    
    @IBAction func dailyESMPressed(_ sender: Any) {
        // base code from github
        let schdule = ESMSchedule.init()
        schdule.notificationTitle = "eWellness"
        schdule.notificationBody = "Please fill the daily questionnaire"
        schdule.scheduleId = "Daily Questionnaire"
        schdule.expirationThreshold = 1440
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
        
//        let radioLast = SingleESMObject.getEsmDictionaryAsRadio(withDeviceId: deviceId,
//                                                                timestamp: NSDate.init().timeIntervalSince1970,
//                                                                title: "[10 of 10] During the PAST DAY, about how often did you feel ...",
//                                                                instructions: "... worthless?",
//                                                                submit: "Submit",
//                                                                expirationThreshold: 0,
//                                                                trigger: "10_radio",
//                                                                radios: ans)
//                    as NSDictionary? as! [AnyHashable : Any]
        
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
        schdule.fireHours = [0,9,15,21]
        
//        let esm = SingleESMObject.getEsmDictionaryAsFreeText(withDeviceId: deviceId,
//                                                             timestamp: NSDate.init().timeIntervalSince1970,
//                                                             title: "Study ID",
//                                                             instructions: "Enter your unique ID here:",
//                                                             submit: "Submit",
//                                                             expirationThreshold: 0,
//                                                             trigger: "studyid")
//        let esm = ESMItem.initWithConfiguration(device_id: deviceId,
//                            timestamp: NSDate.init().timeIntervalSince1970,
//                            title: "Study ID",
//                            instructions: "Enter your unique ID here:",
//                            submit: "Submit",
//                            expirationThreshold: 0,
//                            trigger: "studyid")
            
        let esm = ESMItem.init(asTextESMWithTrigger: "studyid")
        esm.setTitle("Study ID")
        esm.setInstructions("Enter your unique ID here:")
        esm.setSubmitButtonName("Submit")
        esm.setExpirationWithMinute(525600)
        
        schdule.addESM(esm)
        startESM(schedule: schdule, allowClose: false)
    }
    
    func startESM(schedule: ESMSchedule, allowClose: Bool) {
        schedule.interface = 1
        
//        let iOSESM = ESM.init(awareStudy: study, dbType: AwareDBTypeCoreData)
//        let iOSESM = ESM.init(awareStudy: study)
        let manager = ESMScheduleManager.shared()
        manager.debug = true
        manager.removeAllSchedulesFromDB()
        manager.add(schedule)
        
        let esmViewController = ESMScrollViewController.init()
        esmViewController.view.backgroundColor = .white
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
    
//    func hasAnsweredToday() -> Bool {
//        if let ctx = delegate?.managedObjectContext {
//            let req = NSFetchRequest<NSFetchRequestResult>.init()
//            req.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityESMAnswer.self), in: ctx)
//
//            let sort = NSSortDescriptor.init(key: "timestamp", ascending: false)
//            req.sortDescriptors = [sort]
//            let resultsController = NSFetchedResultsController.init(fetchRequest: req, managedObjectContext: ctx, sectionNameKeyPath: nil, cacheName: nil)
//
//            do {
//                try resultsController.performFetch()
//                let results = resultsController.fetchedObjects
//
//                if let results = results {
//                    if results.count < 10 {
//                        return false
//                    }
//
//                    if let answer = results.last as? EntityESMAnswer {
//                        let calendar = NSCalendar.current
//                        let latestDate = Date.init(timeIntervalSince1970: TimeInterval(Int(answer.timestamp!) / 1000))
//                        return calendar.isDateInToday(latestDate)
//                    }
//                }
//
//            } catch {
//                print("Exception thrown when trying to get latest ESM answers")
//            }
//
//        }
//        return false
//    }
    
    func hasAnsweredToday() -> Bool {
        // TODO: Fix crash in this code
        /*let req = NSFetchRequest<NSFetchRequestResult>.init()
        req.entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(EntityESMAnswer.self), in: persistentContainer.viewContext)
        
        let sort = NSSortDescriptor.init(key: "timestamp", ascending: false)
        req.sortDescriptors = [sort]
        let resultsController = NSFetchedResultsController.init(fetchRequest: req, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
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
        */
    return false
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AWARE_ScheduleESM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

