//
//  AppDelegate.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
         FirebaseApp.configure()
        
          window = UIWindow()
          window?.makeKeyAndVisible()
          window?.rootViewController = TabBarViewController()

          return true
      }
}

