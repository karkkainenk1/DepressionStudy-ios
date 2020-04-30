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

import ResearchKit

class ConsentDocument: ORKConsentDocument {
    // MARK: Properties
    
    let ipsum = [
        "This study aims to determine if data that can be collected passively off your phone, can be predictive of your mental wellness at a given time.  Our eventual hope is to create a platform that can predict if a person is in crises and direct help to them without them needing to actively seek out help.",
        // Data Gathering
        "This study will collect data such as location, ambient brightness, ambient sound levels, and steps taken, but will not collect any personally identifiable information.",
        // Privacy
        "Any information that is obtained in connection with this study and that can identify you will remain confidential.",
        // Data Use
        "Data will be used by the research team to look for potential links between mental health and information passively obtainable from a smartphone.",
        // Time commitment
        "This study will require about an hour of your time over the span of a month.",
        // Study Survey
        "You will be asked to complete daily 10 question surveys on your mental state.",
        // Study Tasks
        "You are expected to keep the eWellness app installed on your device and refrain from sharing your device with others.",
        // Withdrawing
        "You can choose whether or not you want to be in this study, and you may withdraw your consent and discontinue participation at any time.",
        // Only in Document
        """
        Dr. Majid Sarrafzadeh, from the Computer Science Department at the University of California, Los Angeles (UCLA) is conducting a research study.

        You were selected as a possible participant in this study because you are a current student, employee or affiliate of the university. Your participation in this research study is voluntary.

        Why is this study being done?

        This study aims to determine if data that can be collected passively off your phone, can be predictive of your mental wellness at a given time. This data is limited to embedded sensors like GPS, light, and accelerometer, and will not collect any personally identifiable information on you. Our eventual hope is to create a platform that can predict if a person is in crises and direct help to them without them needing to actively seek out help.

        What will happen if I take part in this research study?

        If you volunteer to participate in this study, the researcher will ask you to do the following:

        ● Fill out a survey consisting of 24 multiple-choice questions once a week for the duration of the study
        ● Fill out a small daily questionnaire of 10 multiple-choice questions.
        ● Install the app and have it running on your phone in the background throughout the day.

        How long will I be in the research study?

        Participation will take a total of about 1 hour spread over the course of a month’s time.

        The only time requirements for the study will be installing the application, and taking the surveys.

        It is anticipated that the weekly survey will take no more than 5 minutes, and the daily survey no more than 1 minute.

        Are there any potential risks or discomforts that I can expect from this study?

        ● Running a mobile application in the background may negatively impact the battery life and performance of the phone. We have taken steps to diminish the impact of the application, but some degradation is expected.
        ● While the questionnaires are minimally intrusive, it is possible that probing your mental wellness state may engender some discomfort or unease. Please immediately discontinue the study if you feel the questioning to be discomforting.

        Are there any potential benefits if I participate?

        You may benefit from the study by becoming more aware of daily stressors and being more mindful of your mental state.

        The results of the research may be included in future grant proposals or research publications. None of your specific data will be included in any public disclosure.

        What other choices do I have if I choose not to participate?

        As a student or university affiliate, your participation in this study will be entirely voluntary.

        Will I be paid for participating?

        You will receive an Amazon gift card for the successful participation in the survey. This will require your active participation throughout the data collection process. The precise amount offered will be dependent on the duration and consistency of involvement. Failure to remain actively engaged in the study may result in forfeiture of the gift card

        Will information about me and my participation be kept confidential?

        Any information that is obtained in connection with this study and that can identify you will remain confidential. It will be disclosed only with your permission or as required by law. Confidentiality will be maintained by limiting collection solely to non-identifiable data. All collected data will be stored on a secure fully encrypted server, and will only be made available to research study investigators.

        The researchers will do their best to make sure that your private information is kept confidential. Information about you will be handled as confidentially as possible, but participating in research may involve a loss of privacy and the potential for a breach in confidentiality. Study data will be physically and electronically secured. As with any use of electronic means to store data, there is a risk of breach of data security.

        No identifiable information about you will be kept with the research data. All research data and records will be maintained in a secure location at UCLA. Only authorized individuals will have access to it. The research team, authorized UCLA personnel and regulatory agencies such as the Food and Drug Administration (FDA), may have access to study data and records to monitor the study. Research records provided to authorized, non-UCLA personnel will not contain identifiable information about you. Publications and/or presentations that result from this study will not identify you by name. The researchers intend to keep the research data and records indefinitely for future research.

        What are my rights if I take part in this study?

        ● You can choose whether or not you want to be in this study, and you may withdraw your consent and discontinue participation at any time.
        ● Whatever decision you make, there will be no penalty to you, and no loss of benefits to which you were otherwise entitled.
        ● You may refuse to answer any questions that you do not want to answer and still remain in the study.

        Who can I contact if I have questions about this study?

        ● The research team:
        If you have any questions, comments or concerns about the research, you can talk to the one of the researchers. Please contact: Lionel Levine at 213-444-6622 or Lionel@cs.ucla.edu.

        ● UCLA Office of the Human Research Protection Program (OHRPP):
        If you have questions about your rights as a research subject, or you have concerns or suggestions and you want to talk to someone other than the researchers, you may contact the UCLA OHRPP by phone: (310) 206-2040; by email: participants@research.ucla.edu or by mail: Box 951406, Los Angeles, CA 90095-1406.

        By selecting AGREE you acknowledge that you have received and understood the terms of the study. By proceeding to study enrollment you are agreeing to participate in the study.
        """
    ]
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        title = NSLocalizedString("Research Health Study Consent Form", comment: "")
        
        let sectionTypes: [ORKConsentSectionType] = [
            .overview,
            .dataGathering,
            .privacy,
            .dataUse,
            .timeCommitment,
            .studySurvey,
            .studyTasks,
            .withdrawing,
            .onlyInDocument,
        ]
        sections = []
        
        for sectionType in sectionTypes {
            let section = ORKConsentSection(type: sectionType)
            
            let localizedIpsum = NSLocalizedString(ipsum[sectionTypes.firstIndex(of: sectionType)!], comment: "")
            let localizedSummary = localizedIpsum.components(separatedBy: ".")[0] + "."
            
            section.summary = localizedSummary
            section.content = localizedIpsum
            if sectionType != .onlyInDocument {
                section.omitFromDocument = true
            }
            if sections == nil {
                sections = [section]
            } else {
            sections!.append(section)
            }
        }
        
        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        addSignature(signature)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ORKConsentSectionType: CustomStringConvertible {

    public var description: String {
        switch self {
            case .overview:
                return "Overview"
                
            case .dataGathering:
                return "DataGathering"
                
            case .privacy:
                return "Privacy"
                
            case .dataUse:
                return "DataUse"
                
            case .timeCommitment:
                return "TimeCommitment"
                
            case .studySurvey:
                return "StudySurvey"
                
            case .studyTasks:
                return "StudyTasks"
                
            case .withdrawing:
                return "Withdrawing"
                
            case .custom:
                return "Custom"
                
            case .onlyInDocument:
                return "OnlyInDocument"
        }
    }
}
