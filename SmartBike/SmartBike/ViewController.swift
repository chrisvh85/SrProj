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
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startAltitude: CLLocation!
    var lastAltitude: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    var altitudeGained: Double = 0
    var altitudeLost: Double = 0
    var altitudeChange: Double = 0
    var startTime = TimeInterval()
    var timer = Timer()
    let defaults = UserDefaults()
    var elapsedTime: TimeInterval = 0
    @IBOutlet weak var leftToggleButton: UIButton!
    @IBOutlet weak var rightToggleButton: UIButton!
    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        //var location = locations.last!
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        //map.setCenter(myLocation, animated: true)
        map.showsUserLocation = true
        
        speedLabel.text = String(format: "%.0f km/h", locationManager.location!.speed * 3.6);
        if startDate == nil {
            startDate = Date()
        } 
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            traveledDistance += lastLocation.distance(from: location)
            print("Traveled Distance:",  traveledDistance)
            print("Straight Distance:", startLocation.distance(from: locations.last!))
             altitudeChange = lastLocation.altitude.distance(to: location.altitude)
            if altitudeChange >= 0 {
                altitudeGained += altitudeChange
            } else {
                altitudeLost += altitudeChange
            }
            print("Altitude Gained:",  altitudeGained)
            print("Altitude Lost:", altitudeLost)
        }
        lastLocation = locations.last
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isHidden=true
        start.isHidden=false
        timeLabel.isHidden = true
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
       createAlert(title: "Shock", message: "Help")
    }

    
    @IBAction func leftToggleButtonUp(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 0)
    }
    @IBAction func rightToggleButtonDown(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 2)
        
    }
    @IBAction func startButton(_ sender: UIButton) {
        //createAlert(title: "Shock", message: "Help?")
        start.isHidden=true
        stopButton.isHidden=false
        startTracking()
    }
    @IBAction func stopButton(_ sender: UIButton) {
        self.stopButton.isHidden=true
        start.isHidden=false
        stopTracking()
    }
    
    @IBAction func rightToggleButtonUp(_ sender: UIButton) {
        bluetoothIO.writeValue(value: 0)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    func startTracking(){
        locationManager.startUpdatingLocation()
        timeLabel.isHidden = false
        let aSelector : Selector = #selector(ViewController.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate
        traveledDistance = 0
        startLocation = locationManager.location
        
    }
    func stopTracking(){
        timer.invalidate()
        defaults.set(traveledDistance, forKey: "distance")
        print(traveledDistance)
        defaults.set(elapsedTime, forKey: "time")
        print(elapsedTime)
        locationManager.stopUpdatingLocation()
        
    }
    @objc func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate
        //var elapsedTime: TimeInterval = currentTime - startTime
        elapsedTime = currentTime - startTime
        let hours = UInt8(elapsedTime / 60)
        elapsedTime -= (TimeInterval(hours) * 60)
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        timeLabel.text = "\(strHours):\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    func createAlert(title:String, message:String){
        //let defaults = UserDefaults()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                //controller.recipients = [defaults.string(forKey: "contact")!]
                controller.recipients = [self.defaults.string(forKey: "contact")!]
                let lat = String(describing: self.locationManager.location!.coordinate.latitude)
                let long = String(describing: self.locationManager.location!.coordinate.longitude)
                var messageBody = "I just crashed my bike here \n http://maps.apple.com/?daddr=" + lat + "," + long
                controller.body = messageBody
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }

        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
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


