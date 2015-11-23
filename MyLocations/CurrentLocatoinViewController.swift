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
        configureGetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    
    
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
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
        updateLabels()
        configureGetButton()
    }
    
    //tell user the location service is disabled
    func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "定位你没同意", message: "麻溜的去设置改同意了", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func configureGetButton() {
        if updatingLocation {
            //button state:
            //.Normal means it is not pressed
            //.Highlighted means it is pressed
            //.Disabled means when it is disabled
            getButton.setTitle("Stop", forState: .Normal)
        } else {
            getButton.setTitle("Get My Location", forState: .Normal)
        }
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
            
            let statusMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Service Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            }else if !CLLocationManager.locationServicesEnabled() {
                    statusMessage = "Location Service Disabled"
                } else if updatingLocation {
                    statusMessage = "Searching..."
                } else {
                    statusMessage = "Tap \"Get My Location\" to Start"
                }
            
            messageLabel.text = statusMessage
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }


    
    
    // MARK:
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.LocationUnknown.rawValue {
            //CLError.locationUnknown - the location is currently unknown, but core location will keep trying
            //CLError.Denied - the user declined the app to use location services
            //CLError.Network - There was a network-related error
            return
        }
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        //if the newLocation is 5 sec ago, ignore
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        //if newLocation's accuracy less than 0 means the measurements are invalid, should be ignored
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        // if the old location accuracy bigger (bigger means worse accurate), update everything
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            updateLabels()
            //if newLocation accuracy reach the desiredAccuracy, then stop updating location
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                configureGetButton()
            }
        }

    }
    

}

