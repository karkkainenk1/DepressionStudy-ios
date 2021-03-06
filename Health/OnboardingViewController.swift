/*
Copyright (c) 2015, Apple Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3.  Neither the name of the copyright holder(s) nor the names of any contributors
may be used to endorse or promote products derived from this software without
specific prior written permission. No license is granted to the trademarks of
the copyright holders even if such marks are included in this software.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import ResearchKit

class OnboardingViewController: UIViewController {
    @IBAction func startOnboarding(_ sender: Any) {        
        // Welcome View Controller
        let welcomeStep = ORKInstructionStep(identifier: "welcomeStepIdentifier")
        welcomeStep.title = "Welcome to eWellness"
        welcomeStep.detailText = "This study aims to determine if data that can be collected passively off your phone, can be predictive of your mental wellness at a given time.  Our eventual hope is to create a platform that can predict if a person is in crises and direct help to them without them needing to actively seek out help."
        welcomeStep.iconImage = UIImage(named: "graph")!.withRenderingMode(.alwaysTemplate)
        
        
        let mentalStep = ORKInstructionStep(identifier: "mentalStepIdentifier")
        mentalStep.title = "Mental Health Note"
        mentalStep.detailText =
            """
            A brief note on your mental health:

            Our daily survey will be prompting you for information on your mental well-being. This will include some specific prompts around your feelings of depression and anxiety. Although this information is being recorded for the study, your responses will not be reviewed regularly by researchers.

            As such, if you ever feel overwhelmed, or that you need help, please do not expect us to detect this and act on your behalf, but instead reach out to the appropriate resource. We’ve included a ‘Need Help?’ tab in the menu with contact info for a variety of UCLA and community resources available to you.
            """
        if #available(iOS 13.0, *) {
            mentalStep.iconImage = UIImage(systemName: "info")!.withRenderingMode(.alwaysTemplate)
        } else {
            // Fallback on earlier versions
            mentalStep.iconImage = UIImage(named: "graph")!.withRenderingMode(.alwaysTemplate)
        }
        
        // What to Expect
        let whatToExpectStep = ORKTableStep(identifier: "whatToExpectStep")
        whatToExpectStep.title = "What to Expect"
        whatToExpectStep.text = "You'll keep the eWellness app on your phone for the duration of the study, and it will collect some information potentially relevant to your mental state. Some additional key points follow:"
        whatToExpectStep.items = [
            "You'll use your phone to respond to short questionnaires" as NSString,
            "This study will last for approximately one month" as NSString,
            "This study is run by the ER-Lab at UCLA" as NSString
        ]
        whatToExpectStep.bulletIconNames = ["phone", "calendar", "share"]
        whatToExpectStep.bulletType = .image
        
        let consentDocument = ConsentDocument()
//        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)

//        let healthDataStep = HealthDataStep(identifier: "Health")
        
        let signature = consentDocument.signatures!.first!
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.requiresScrollToBottom = true
        
        reviewConsentStep.text = "Review the consent form."
        reviewConsentStep.reasonForConsent = "Consent to join the eWellness Research Study."
        
        let permissionsStep = PermissionStep(identifier: "permissionsStepIdentifier")
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome aboard."
        completionStep.text = """
        After pressing continue, two things will happen.
        
        1. A number of windows will appear requesting permissions. These are necessary for the study.
        
        2. A study ID window will appear. Please enter any four digit combination. This number will serve as your identifier for the study and it cannot be changed.

        Thank you for your participation.
        """
         
        let orderedTask = ORKOrderedTask(identifier: "Join", steps: [welcomeStep, whatToExpectStep, mentalStep, reviewConsentStep, permissionsStep, completionStep])
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
}

extension OnboardingViewController: ORKTaskViewControllerDelegate {
    
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
            case .completed:
//                performSegue(withIdentifier: "unwindToStudy", sender: nil)
//                performSegue(withIdentifier: "startStudy", sender: nil)
                performSegue(withIdentifier: "toStudy", sender: self)

            case .discarded, .failed, .saved:
                dismiss(animated: true, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is PermissionStep {
            let permissionStepViewController = PermissionDataStepViewController(step: step)
            return permissionStepViewController
        }
        
        return nil
    }
}
