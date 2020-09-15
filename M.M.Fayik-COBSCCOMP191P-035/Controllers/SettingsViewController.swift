//
//  SettingsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SettingsViewController: UIViewController {
  
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: "Avenir-Light", size: 30)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let BackButton: UIButton = {
           let button = UIButton()
        // button.setTitle("Back", for: .normal)
           button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
           button.addTarget(self, action: #selector(showHomeController), for: UIControl.Event.touchUpInside)

        return button
     }()
    
    private let SignOutButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("L O G O U T", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        return button
        
    }()
//
//    private let ProfileButton: UIButton = {
//
//        let button = UIButton()
//        button.setTitle("Profile", for: .normal)
//        button.backgroundColor = UIColor.white
//        button.setTitleColor(.black, for: .normal)
//        button.contentHorizontalAlignment = .left
//        button.addTarget(self, action: #selector(showProfile), for: UIControl.Event.touchUpInside)
//
//        return button
//
//    }()
//
//    private let AboutButton: UIButton = {
//
//        let button = UIButton()
//        button.setTitle("Contact Us / About Us", for: .normal)
//        button.backgroundColor = UIColor.white
//        button.setTitleColor(.black, for: .normal)
//        button.contentHorizontalAlignment = .left
//        button.addTarget(self, action: #selector(showContactUs), for: UIControl.Event.touchUpInside)
//
//        return button
//
//    }()
//
//    private let ShareFButton: UIButton = {
//
//        let button = UIButton()
//        button.setTitle("Share with friend", for: .normal)
//        button.backgroundColor = UIColor.white
//        button.setTitleColor(.black, for: .normal)
//        button.contentHorizontalAlignment = .left
//        //  button.addTarget(self, action: #selector(signOut), for: UIControl.Event.touchUpInside)
//
//        return button
//
//    }()
    
    private let profileTile: UIButton = {
          let tile = UIButton()
          tile.backgroundColor = .white
          
          let title = UILabel()
          title.text = "Profile"
          title.textColor = .black
          tile.addSubview(title)
          title.anchor(top: tile.topAnchor, left: tile.leftAnchor, bottom: tile.bottomAnchor, paddingLeft: 20)
          title.centerY(inView: tile)
          
          let arrow = UIImageView()
          arrow.image = UIImage(systemName: "chevron.right")
          arrow.tintColor = .black
          arrow.layer.masksToBounds = true
          tile.addSubview(arrow)
          arrow.anchor(right: tile.rightAnchor, paddingRight: 20, width: 14, height: 24)
          arrow.centerY(inView: tile)
          
          let separatorView = UIView()
          separatorView.backgroundColor = .lightGray
          tile.addSubview(separatorView)
          separatorView.anchor(left: tile.leftAnchor, bottom: tile.bottomAnchor, right: tile.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 0.75)
          
          tile.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
          
          return tile
      }()
      
      private let contactTile: UIButton = {
          let tile = UIButton()
          tile.backgroundColor = .white
          
          let title = UILabel()
          title.text = "Contact Us / About Us"
          title.textColor = .black
          tile.addSubview(title)
          title.anchor(top: tile.topAnchor, left: tile.leftAnchor, bottom: tile.bottomAnchor, paddingLeft: 20)
          title.centerY(inView: tile)
          
          let arrow = UIImageView()
          arrow.image = UIImage(systemName: "chevron.right")
          arrow.tintColor = .black
          arrow.layer.masksToBounds = true
          tile.addSubview(arrow)
          arrow.anchor(right: tile.rightAnchor, paddingRight: 20, width: 14, height: 24)
          arrow.centerY(inView: tile)
          
          let separatorView = UIView()
          separatorView.backgroundColor = .lightGray
          tile.addSubview(separatorView)
          separatorView.anchor(left: tile.leftAnchor, bottom: tile.bottomAnchor, right: tile.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 0.75)
          
          tile.addTarget(self, action: #selector(showContactUs), for: .touchUpInside)
          
          return tile
      }()
      
      private let shareTile: UIButton = {
          let tile = UIButton()
          tile.backgroundColor = .white
          
          let title = UILabel()
          title.text = "Share with friend"
          title.textColor = .systemBlue
          tile.addSubview(title)
          title.anchor(top: tile.topAnchor, left: tile.leftAnchor, bottom: tile.bottomAnchor, paddingLeft: 20)
          title.centerY(inView: tile)
          
          let arrow = UIImageView()
          arrow.image = UIImage(systemName: "chevron.right")
          arrow.layer.masksToBounds = true
          tile.addSubview(arrow)
          arrow.anchor(right: tile.rightAnchor, paddingRight: 20, width: 14, height: 24)
          arrow.centerY(inView: tile)
                  
          tile.addTarget(self, action: #selector(showContactUs), for: .touchUpInside)
          
          return tile
      }()
      
      private let blankView: UIView = {
          let blank = UIView()
          blank.backgroundColor = .white
          
          let separatorView = UIView()
          separatorView.backgroundColor = .lightGray
          blank.addSubview(separatorView)
          separatorView.anchor(left: blank.leftAnchor, bottom: blank.bottomAnchor, right: blank.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 0.75)
          
          return blank
      }()
      
//      private let logoutButton: UIButton = {
//          let button = UIButton()
//          button.backgroundColor = .white
//          button.setTitle("L O G O U T", for: .normal)
//          button.setTitleColor(.black, for: .normal)
//          button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
//          button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
//          return button
//      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGray6
        tabBarController?.tabBar.isHidden = true
        checkIsUserLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .systemGray6
        tabBarController?.tabBar.isHidden = true
        checkIsUserLoggedIn()
    }
    
    func checkIsUserLoggedIn() {
           if(Auth.auth().currentUser?.uid == nil) {
               DispatchQueue.main.async {
                   let nav = UINavigationController(rootViewController: LoginViewController())
                   nav.modalPresentationStyle = .fullScreen
                   self.present(nav, animated: true, completion: nil)
               }
           } else {
               LoadUI()
           }
       }
    
    func LoadUI() {
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [profileTile, contactTile, shareTile])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 0
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 210)
        
//        view.addSubview(logoutButton)
//        logoutButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 60)
        view.addSubview(SignOutButton)
        SignOutButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        
        view.addSubview(blankView)
        blankView.anchor(top: stack.bottomAnchor, left: view.leftAnchor, bottom: SignOutButton.topAnchor, right: view.rightAnchor)
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
//
//        view.addSubview(ProfileButton)
//        ProfileButton.anchor(top: titleLabel.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 35, paddingLeft: 12, paddingRight: 0)
//
//        view.addSubview(AboutButton)
//        AboutButton.anchor(top: ProfileButton.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 12, paddingRight: 0)
//
//        view.addSubview(ShareFButton)
//        ShareFButton.anchor(top: AboutButton.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 12, paddingRight: 0)
//
       
//
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
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
    @objc func showProfile() {
        let profile = ProfileViewController()
        profile.modalPresentationStyle = .fullScreen
        present(profile, animated: true, completion: {
            // profile
        })
    }
    @objc func showContactUs() {
        let con = ContactUsViewController()
        con.modalPresentationStyle = .fullScreen
        present(con, animated: true, completion: {
            // contactUs
        })
    }
    
}
