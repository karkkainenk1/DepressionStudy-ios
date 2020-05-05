//
//  ChartViewController.swift
//  Health
//
//  Created by Kimmo Kärkkäinen on 5/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import ResearchKit
import UIKit

class ChartViewController: UIViewController {

  @IBOutlet weak var pedometerGraphView: ORKLineGraphChartView!
  @IBOutlet weak var activityGraphView: ORKLineGraphChartView!

  let pedometerDatasource = PedometerDataSource()
  let activityDatasource = ActivityDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    pedometerGraphView.dataSource = pedometerDatasource
    pedometerGraphView.showsVerticalReferenceLines = true
    pedometerGraphView.showsHorizontalReferenceLines = true
    activityGraphView.dataSource = activityDatasource
    activityGraphView.showsVerticalReferenceLines = true
    activityGraphView.showsHorizontalReferenceLines = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    pedometerGraphView.reloadData()
    activityGraphView.reloadData()
  }

  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
