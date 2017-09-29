//
//  ViewController.swift
//  SmartBike
//
//  Created by Shubaan Taheri on 9/22/17.
//  Copyright © 2017 Shubaan Taheri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var bluetoothIO: BluetoothIO!
    @IBOutlet weak var leftToggleButton: UIButton!
    @IBOutlet weak var rightToggleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothIO = BluetoothIO(serviceUUID: "19B10010-E8F2-537E-4F6C-D104768A1214", delegate: self)
    }


    @IBAction func leftToggleButtonDown(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 1)
    }
    
    @IBAction func leftToggleButtonUp(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 0)
    }
    @IBAction func rightToggleButtonDown(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 2)
        
    }
    
    @IBAction func rightToggleButtonUp(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 0)
    }
    func changeBackgroundColor(color:UIColor){
        view.backgroundColor = color
    }
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.changeBackgroundColor(color: UIColor.black)
        }))
        self.present(alert, animated: true, completion: nil)
    }


}

extension ViewController: BluetoothIODelegate {
    func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8) {
        if value > 0 {
            view.backgroundColor = UIColor.red
            createAlert(title: "Shock Detected", message: "Send for Help?")
        } else {
            view.backgroundColor = UIColor.black
        }
    }
}


