//
//  TabBarViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/24/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController {
    
  //  let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tab()
    }
    func tab() {
        
        let homeViewController = HomeDashBoardViewController()
        homeViewController.tabBarItem.image = #imageLiteral(resourceName: "Home2x")
        homeViewController.tabBarItem.title = "HOME"
        
        let updateViewController = UpdateViewController()
        updateViewController.tabBarItem.image = #imageLiteral(resourceName: "Plus2x")
        updateViewController.tabBarItem.title = "UPDATE"
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        settingsViewController.tabBarItem.title = "SETTINGS"
        
//        tabBar.viewControllers = [homeViewController,updateViewController,settingsViewController]
//        self.view.addSubview(tabBar.view)
        viewControllers = [homeViewController,updateViewController,settingsViewController]
        
    }
}
