//
//  TabBarViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/24/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UIViewController {
    
  //  private let mapView = MKMapView()
  // private let locationManager = CLLocationManager()
    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tab()
    }
    func tab() {
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem.image = #imageLiteral(resourceName: "icons8-home-page-100")
        homeViewController.tabBarItem.title = "HOME"
        
        let updateViewController = UpdateViewController()
        updateViewController.tabBarItem.image = #imageLiteral(resourceName: "icons8-add-100")
        updateViewController.tabBarItem.title = "UPDATE"
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem.image = #imageLiteral(resourceName: "icons8-settings-100")
        settingsViewController.tabBarItem.title = "SETTINGS"
        
        tabBar.viewControllers = [homeViewController,updateViewController,settingsViewController]
        self.view.addSubview(tabBar.view)
    }
//    func configureUi()
//    {
//        tab()
//        view.addSubview(mapView)
//        mapView.sizeToFit()
//
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
//    }
}
