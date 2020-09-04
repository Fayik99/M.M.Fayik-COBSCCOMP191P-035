//
//  UpdateViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class UpdateViewController: UIViewController {

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
    
    private let StartSurveyButton: AuthUIButton = {
        let button = AuthUIButton(type: .system)
        button.setTitle("Go to Survey", for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(showSurveyController), for: UIControl.Event.touchUpInside)
        
        return button
        
    }()
    
    private let tempUpdate: UITextField = {
        
       let txtField = UITextField()
       txtField.placeholder = ("Update Temparature")
        txtField.keyboardType = .numberPad
       txtField.isSecureTextEntry = false

       return txtField
    }()
    
    private let SubmitTempButton: AuthUIButton = {
        let button = AuthUIButton(type: .system)
        button.setTitle("Update Temparature", for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(TempUpdateFb), for: UIControl.Event.touchUpInside)
        
        return button
        
    }()
    
    private lazy var updateTempContainer: UIView = {
       
        return UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-name-100"), textField: tempUpdate as UITextField)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
         checkIsUserLoggedIn()
       //  setUI()
     //   tabBarController?.tabBar.isHidden = true
    }
    
        func checkIsUserLoggedIn() {
            if(Auth.auth().currentUser?.uid == nil) {
                DispatchQueue.main.async {
                    let nav = UINavigationController(rootViewController: LoginViewController())
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            } else {
                   setUI()
            }
        }
      
    func setUI() {
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 20, paddingLeft: 15, width: 30, height: 25)
        
        view.addSubview(StartSurveyButton)
        StartSurveyButton.anchor(top: BackButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        let stack = UIStackView(arrangedSubviews: [updateTempContainer, SubmitTempButton])
        view.addSubview(stack)
        stack.axis = .vertical
        
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.anchor(top: StartSurveyButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        
    }
    
    @objc func showSurveyController() {
        let home = CvSurveyViewController()
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true, completion: {
            // Survey
        })
    }
    @objc func showHomeController() {
        let home = TabBarViewController()
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true, completion: {
            // Back
        })
    }
    @objc func TempUpdateFb() {
        
        guard let TempUpdate = tempUpdate.text else { return }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "Body Temparature": TempUpdate,
            ] as [String : Any]
        
    
        Database.database().reference().child("user temparature").child(userID).updateChildValues(values) { (error, ref) in
                
                print("DEBUG: Data saved.")
            }
        }
    }

