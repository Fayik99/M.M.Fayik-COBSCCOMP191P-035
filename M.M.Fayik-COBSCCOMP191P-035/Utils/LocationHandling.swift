//
//  LocationHandling.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/26/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import CoreLocation

class LocationHandling: NSObject, CLLocationManagerDelegate {
    static let shared = LocationHandling()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}
