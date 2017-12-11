//
//  RideSummaryViewController.swift
//  SmartBike
//
//  Created by Shubaan Taheri on 11/29/17.
//  Copyright © 2017 Shubaan Taheri. All rights reserved.
//

import Foundation
import UIKit

class RideSummaryViewController: UIViewController {
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var topSpeedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let defaults = UserDefaults()
    
    var altitude: Double = 0
    
    var avgSpeed: Double = 0
    
    var topSpeed: Double = 0
    
    var time: String = ""
    
    var distance: Double = 0
    
    var calories: String = "Coming Soon"
    

  
    override func viewDidLoad() {
        let units = defaults.string(forKey: "units")
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if(units == "M"){
                self.distanceLabel.text = String(format: "%.2f Miles", Double(self.defaults.string(forKey: "distance")!)! * 0.000621371)
                self.avgSpeedLabel.text = String(format: "%.2f MPH", Double(self.defaults.string(forKey: "avgSpeed")!)! * 2.24)
                self.topSpeedLabel.text = String(format: "%.2f MPH", Double(self.defaults.string(forKey: "topSpeed")!)! * 2.24)
            }
            else{
                self.distanceLabel.text = String(format: "%.2f KM", Double(self.defaults.string(forKey: "distance")!)! * 0.001)
                self.avgSpeedLabel.text = String(format: "%.2f KM/H", Double(self.defaults.string(forKey: "avgSpeed")!)! * 3.6)
                self.topSpeedLabel.text = String(format: "%.2f KM/H", Double(self.defaults.string(forKey: "topSpeed")!)! * 3.6)
            }
            
            
            self.timeLabel.text = self.defaults.string(forKey: "time")
            self.altitudeLabel.text = self.defaults.string(forKey: "altitude")
            self.caloriesLabel.text = self.calories
            self.distanceLabel.isHidden = false
            self.timeLabel.isHidden = false
            self.altitudeLabel.isHidden = false
            self.avgSpeedLabel.isHidden = false
            self.caloriesLabel.isHidden = false
            self.topSpeedLabel.isHidden = false
        }
    
    }
}
