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
    
    @IBAction func unitChange(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex){
        case 0:
            defaults.set("M", forKey: "units")
            print(defaults.string(forKey: "units")!)
        case 1:
            defaults.set("K", forKey: "units")
            print(defaults.string(forKey: "units")!)

        default:
            break
        }
    }
    
    @IBOutlet var weight: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var unit: UISegmentedControl!
    let defaults = UserDefaults()
    override func viewDidLoad() {
        weak var unit: UISegmentedControl!
        weight.delegate = self
        phoneNumber.text = defaults.string(forKey: "weight")
        phoneNumber.delegate = self
        phoneNumber.text = defaults.string(forKey: "contact")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumber.resignFirstResponder()
        weight.resignFirstResponder()

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        defaults.set(phoneNumber.text, forKey: "contact")
        defaults.set(weight.text, forKey: "weight")
    }
}
