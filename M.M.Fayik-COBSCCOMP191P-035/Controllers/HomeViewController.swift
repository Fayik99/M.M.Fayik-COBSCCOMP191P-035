//
//  HomeViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        checkIsUserLoggedIn()
        //signOut()
        
        AccessLocationServices()
    }
    
    func checkIsUserLoggedIn() {
        if(Auth.auth().currentUser?.uid == nil) {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }  else {
            configureUi()
        }
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("ERROR: Sign out")
        }
    }
    
    func configureUi()
      {
          view.addSubview(mapView)
          mapView.frame = view.frame
          
          mapView.showsUserLocation = true
          mapView.userTrackingMode = .follow
      }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func AccessLocationServices() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func  configureNavigationBar()
    {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
}




