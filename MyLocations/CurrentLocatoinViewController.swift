//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Shaohui Yang on 11/19/15.
//  Copyright © 2015 Shaohui Yang. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocatoinViewController: UIViewController, CLLocationManagerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()//ask user for location permission
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServiceDeniedAlert()
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    //tell user the location service is disabled
    func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "定位你没同意", message: "麻溜的去设置改同意了", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.hidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addresLabel.text = ""
            tagButton.hidden = true
            messageLabel.text = "Tap \"Get My Location\" to Start"
        }
    }


    
    
    // MARK:
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("DidFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        location = newLocation
        updateLabels()
    }
    

}

