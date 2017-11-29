//
//  moreViewController.swift
//  SmartBike
//
//  Created by Shubaan Taheri on 10/20/17.
//  Copyright © 2017 Shubaan Taheri. All rights reserved.
//

import Foundation
import UIKit

class MoreViewController: UIViewController, UITextFieldDelegate{
    
        @IBOutlet var phoneNumber: UITextField!
    
    @IBOutlet var unit: UISegmentedControl!
    let defaults = UserDefaults()
    override func viewDidLoad() {
        phoneNumber.delegate = self
        //let defaults = UserDefaults()
        phoneNumber.text = defaults.string(forKey: "contact")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumber.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       // let defaults = UserDefaults()
        defaults.set(phoneNumber.text, forKey: "contact")
    }
}
