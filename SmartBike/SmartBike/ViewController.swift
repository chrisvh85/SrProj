//
//  ViewController.swift
//  SmartBike
//
//  Created by Shubaan Taheri on 9/22/17.
//  Copyright © 2017 Shubaan Taheri. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI


class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var bluetoothIO: BluetoothIO!
    @IBOutlet weak var leftToggleButton: UIButton!
    @IBOutlet weak var rightToggleButton: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var speedLabel: UILabel!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        speedLabel.text = String(format: "%.0f km/h", locationManager.location!.speed * 3.6);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothIO = BluetoothIO(serviceUUID: "19B10010-E8F2-537E-4F6C-D104768A1214", delegate: self)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        speedLabel.text = "0"
        
        
    }

    

    func updateSpeed(){
        speedLabel.text = String(format: "%.0f km/h", locationManager.location!.speed * 3.6)

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
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createAlert(title:String, message:String){
        let defaults = UserDefaults()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.recipients = [defaults.string(forKey: "contact")!]
                let lat = String(describing: self.locationManager.location!.coordinate.latitude)
                let long = String(describing: self.locationManager.location!.coordinate.longitude)
                var messageBody = "I just crashed my bike here \n http://maps.apple.com/?ll=" + lat + "," + long
                controller.body = messageBody
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }

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


