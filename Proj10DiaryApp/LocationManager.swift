//
//  LocationManager.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/3/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    static let sharedLocationInstance = LocationManager()
    var locationManager:CLLocationManager!
    var street: String?
    var city: String?
    var state: String?
    
    
    
    func determineMyCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
            
        if error != nil {
            print(error ?? "Unknown Error")
        } else {
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
 
            // Get Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                self.street = street
            }
            // Get City
            if let city = placeMark.addressDictionary!["City"] as? String {
                self.city = city
            }
            // Get State
            if let state = placeMark.addressDictionary!["State"] as? String {
                    self.state = state
            }
            }
        }
}
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location \(error.localizedDescription)")
    }
    
}
