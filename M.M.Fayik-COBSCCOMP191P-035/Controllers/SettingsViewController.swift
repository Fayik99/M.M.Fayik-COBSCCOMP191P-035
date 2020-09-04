//
//  SettingsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
     private let BackButton: UIButton = {
           let button = UIButton()
        // button.setTitle("Back", for: .normal)
           button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        // button.backgroundColor = UIColor.blue
       //  button.titleLabel?.textColor = UIColor.white
        // button.layer.borderColor = UIColor.darkGray.cgColor
       //  button.layer.borderWidth = 3.0
           button.addTarget(self, action: #selector(showHomeController), for: UIControl.Event.touchUpInside)
    
    return button
     }()

    private let SignOutButton: AuthUIButton = {
        let button = AuthUIButton(type: .system)
        button.setTitle("Sign out", for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(signOut), for: UIControl.Event.touchUpInside)
        
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        tabBarController?.tabBar.isHidden = true
        LoadUI()
    }
    
    func LoadUI() {
        
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 20, paddingLeft: 15, width: 30, height: 25)
    
        view.addSubview(SignOutButton)
        SignOutButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 60, paddingRight: 60)
        
    }
    
    
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
//               let nav = UINavigationController(rootViewController: HomeViewController())
                let nav = TabBarViewController()
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: {
                     //  Back to home
                })
            }
        } catch {
            print("DEBUG: Sign out error")
        }
    }
    @objc func showHomeController() {
        let home = TabBarViewController()
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true, completion: {
            // Back
        })
    }
    
}
