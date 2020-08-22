//
//  MainTabBarViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

        override func viewDidLoad() {
            super.viewDidLoad()

            tabBar.barTintColor = UIColor.white
                //UIColor(red: 38/255, green: 196/255, blue: 133/255, alpha: 1)
            tab()
        }
        
        func tab() {
            
            let homeViewController = UINavigationController(rootViewController: HomeViewController())
            homeViewController.tabBarItem.image = #imageLiteral(resourceName: "icons8-home-page-100")
            homeViewController.tabBarItem.title = "HOME"
            
            let updateViewController = UINavigationController(rootViewController: UpdateViewController())
            updateViewController.tabBarItem.image = #imageLiteral(resourceName: "icons8-add-100")
            updateViewController.tabBarItem.title = "UPDATE"
            
            let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
            settingsViewController.tabBarItem.image = #imageLiteral(resourceName: "icons8-settings-100")
            settingsViewController.tabBarItem.title = "SETTINGS"
            
            
            
            viewControllers = [homeViewController,updateViewController,settingsViewController]
         
        }
    }
