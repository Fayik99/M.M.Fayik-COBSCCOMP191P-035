//
//  CreateNotificationsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/16/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

class CreateNotificationsViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Notifications +"
        label.font = UIFont(name: "Avenir-medium", size: 25)
        label.textColor = .black
        return label
    }()
    
    private let BackButton: UIButton = {
        let button = UIButton()
        // button.setTitle("Back", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(showUpdateController), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let notificationUpdateUIView: UIView = {
        
        let tileView = UIView()
        tileView.backgroundColor = .white
        tileView.layer.cornerRadius = 5
        tileView.layer.masksToBounds = true
        return tileView
    }()
    
    private let createNotificationTF: UITextField = {
        
        let name = UITextField()
        name.borderStyle = .roundedRect
        name.font = UIFont(name: "Avenir-medium", size: 18)
        name.textColor = .black
        name.keyboardAppearance = .dark
        name.isSecureTextEntry = false
        name.placeholder = "Type here..."
        name.textAlignment = .left
        
        return name
    }()
    
    private let SubmitNotificationsBtn: AuthUIButton = {
        
        let button = AuthUIButton(type: .system)
        button.setTitle("C R E A T E", for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth  = 1.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(white: 0.5, alpha: 1.5), for: .normal)
       // button.addTarget(self, action: #selector(TempUpdateFb), for: UIControl.Event.touchUpInside)
        
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        LoadUI()
    }
    
     func LoadUI() {
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: BackButton.bottomAnchor, left: view.leftAnchor, paddingTop: 18, paddingLeft: 16)
        titleLabel.centerX(inView: view)
        
        view.addSubview(notificationUpdateUIView)
        notificationUpdateUIView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 22, paddingLeft: 12, paddingRight: 12, height: 250)
        
        view.addSubview(createNotificationTF)
        createNotificationTF.anchor(top: notificationUpdateUIView.topAnchor, left: notificationUpdateUIView.leftAnchor, right: notificationUpdateUIView.rightAnchor, paddingTop: 12, paddingLeft: 14, paddingRight: 14, height: 120)
        
        
        view.addSubview(SubmitNotificationsBtn)
        SubmitNotificationsBtn.anchor(top: createNotificationTF.bottomAnchor, left: notificationUpdateUIView.leftAnchor, right: notificationUpdateUIView.rightAnchor, paddingTop: 25, paddingLeft: 70, paddingRight: 70, height: 50)

    }
    
    @objc func showUpdateController() {
        let submit = UpdateViewController()
        submit.modalPresentationStyle = .fullScreen
        present(submit, animated: true, completion: {
        })
    }
}
