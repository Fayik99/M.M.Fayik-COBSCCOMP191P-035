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
        button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(showHomeController), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "C R E A T E +"
           label.font = UIFont(name: "Avenir-Light", size: 25)
           label.textColor = .black
           return label
       }()
    
    // Staff notification create
    
    private let createNotificationMain: UIButton = {
        let tileView = UIButton()
        tileView.backgroundColor = .white
        tileView.layer.cornerRadius = 5
        tileView.layer.masksToBounds = true
        tileView.addTarget(self, action: #selector(showSurveyController), for: .touchUpInside)
        return tileView
    }()
    
    private let createNotificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Notifications"
        label.font = UIFont(name: "Avenir-Medium", size: 18)
        label.textColor = UIColor.black
        //label.backgroundColor = .red
        return label
    }()
    
    private let createNotificationsButton: UIButton = {
        let button = UIButton(type: .custom)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: boldConfig), for: .normal)
        //button.backgroundColor = .green
        return button
    }()
    
    // New Survey
//    private let StartSurveyButton: AuthUIButton = {
//        let button = AuthUIButton(type: .system)
//        button.setTitle("Go to Survey", for: .normal)
//        button.backgroundColor = UIColor.black
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
//        button.addTarget(self, action: #selector(showSurveyController), for: UIControl.Event.touchUpInside)
//
//        return button
//    }()
    private let newSurveyMain: UIButton = {
        let tileBtn = UIButton()
        tileBtn.backgroundColor = .white
        tileBtn.layer.cornerRadius = 5
        tileBtn.layer.masksToBounds = true
        tileBtn.addTarget(self, action: #selector(showSurveyController), for: .touchUpInside)
        return tileBtn
    }()
    
    private let newSurveyLabel: UILabel = {
        let label = UILabel()
        label.text = "New Survey"
        label.numberOfLines = 3
        label.font = UIFont(name: "Avenir-Medium", size: 18)
        label.textColor = UIColor.black
        //label.backgroundColor = .red
        return label
    }()
    
    private let newSurveyButton: UIButton = {
        let button = UIButton(type: .custom)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: boldConfig), for: .normal)
        //button.backgroundColor = .green
        button.addTarget(self, action: #selector(showSurveyController), for: .touchUpInside)
        return button
    }()
    
    private let tempUpdate: UITextField = {
        
       let txtField = UITextField()
       txtField.placeholder = ("Update Temperature")
       txtField.keyboardType = .decimalPad
       txtField.isSecureTextEntry = false

       return txtField
    }()
    
    // Temp Body
    private let tempUpdateUIView: UIView = {
        
        let tileView = UIView()
        tileView.backgroundColor = .white
        tileView.layer.cornerRadius = 5
        tileView.layer.masksToBounds = true
        return tileView
    }()
    
    private let LastUpdateLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Body Temperature"
      //  label.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    
    private let SubmitTempButton: AuthUIButton = {
        
        let button = AuthUIButton(type: .system)
        button.setTitle("U P D A T E", for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth  = 1.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(white: 0.5, alpha: 1.5), for: .normal)
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
      // tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.systemGray6
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
            setUI()
        }
    }
    
    func setUI() {
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: BackButton.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 16)
        titleLabel.centerX(inView: view)
        
        // Staff notification
        
        view.addSubview(createNotificationMain)
        createNotificationMain.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 18, paddingLeft: 16, paddingRight: 16, height: 70)
        
        view.addSubview(createNotificationLabel)
        createNotificationLabel.anchor(top: createNotificationMain.topAnchor, left: createNotificationMain.leftAnchor, paddingLeft: 25)
        createNotificationLabel.centerY(inView: createNotificationMain)
        
        view.addSubview(createNotificationsButton)
        createNotificationsButton.anchor(top: createNotificationMain.topAnchor, right: createNotificationMain.rightAnchor, width: 60)
        createNotificationsButton.centerY(inView: createNotificationMain)
        
        // Survey
        view.addSubview(newSurveyMain)
        newSurveyMain.anchor(top: createNotificationMain.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 70)
        
        view.addSubview(newSurveyLabel)
        newSurveyLabel.anchor(top: newSurveyMain.topAnchor, left: newSurveyMain.leftAnchor, paddingLeft: 25)
        newSurveyLabel.centerY(inView: newSurveyMain)
        
        view.addSubview(newSurveyButton)
        newSurveyButton.anchor(top: newSurveyMain.topAnchor, right: newSurveyMain.rightAnchor, width: 60)
        newSurveyButton.centerY(inView: newSurveyMain)
        
        // Update Temp
        
        view.addSubview(tempUpdateUIView)
        tempUpdateUIView.anchor(top: newSurveyMain.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16, height: 220)
        
       view.addSubview(LastUpdateLabel)
        LastUpdateLabel.anchor(top: tempUpdateUIView.topAnchor, left: tempUpdateUIView.leftAnchor, right: tempUpdateUIView.rightAnchor, paddingTop: 10, paddingLeft: 50, paddingRight: 50, height: 70)

        let stack = UIStackView(arrangedSubviews: [updateTempContainer, SubmitTempButton])
        view.addSubview(stack)
        stack.axis = .vertical
        
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.anchor(top: LastUpdateLabel.bottomAnchor, left: tempUpdateUIView.leftAnchor, right: tempUpdateUIView.rightAnchor, paddingTop: 10, paddingLeft: 60, paddingRight: 60)
        
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user body temparature value
            let value = snapshot.value as? NSDictionary
            let temparature = value?["bodyTemperature"] as? String ?? ""
            self.LastUpdateLabel.text = "\(temparature)"+"°C"
            
            // ...
        }) { (error) in
            print("Body temperature not found")
        }
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
            "bodyTemperature": TempUpdate,
            ] as [String : Any]
        
        if TempUpdate.isEmpty {
            
            let ac = UIAlertController(title: "Temperature Update", message: "Type your temperature", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        else {
            // Database.database().reference().child("user temperature").child(userID).updateChildValues(values) { (error, ref) in
            Database.database().reference().child("users").child(userID).updateChildValues(values) { (error, ref) in
                
                print("DEBUG: Data saved...")
                self.setUI()
                self.tempUpdate.text = ""
            }
        }
    }
}

