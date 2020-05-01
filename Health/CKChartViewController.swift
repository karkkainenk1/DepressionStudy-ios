//
//  CKChartViewController.swift
//  Health
//
//  Created by Tyler Davis on 4/30/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import CareKit


class CKChartViewController: OCKListViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Trends"
        let chartView = OCKCartesianChartView(type: .line)

        chartView.headerView.titleLabel.text = "Doxylamine"

        chartView.graphView.dataSeries = [
             OCKDataSeries(values: [0, 1, 1, 2, 3, 3, 2], title: "Doxylamine")
        ]


        self.appendView(chartView, animated: false)
    }
//    override func viewWillAppear(_ animated: Bool) {
//       let chartView = OCKCartesianChartView(type: .bar)
//
//       chartView.headerView.titleLabel.text = "Doxylamine"
//
//       chartView.graphView.dataSeries = [
//           OCKDataSeries(values: [0, 1, 1, 2, 3, 3, 2], title: "Doxylamine")
//       ]
//
//
//      self.appendView(chartView, animated: false)
//
//    }
}
