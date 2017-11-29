//
//  RideSummaryViewController.swift
//  SmartBike
//
//  Created by Shubaan Taheri on 11/29/17.
//  Copyright © 2017 Shubaan Taheri. All rights reserved.
//

import Foundation
import UIKit

class RideSummaryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var AvgSpeed: UILabel!
    
    let defaults = UserDefaults()
    override func viewDidLoad() {
        var distance = defaults.string(forKey: "distance")
        var time = defaults.string(forKey: "time")
        Distance.text = distance
        Time.text = time
        //AvgSpeed.text = String(Double(distance!)!/Double(time!)!)
        
    }
}
