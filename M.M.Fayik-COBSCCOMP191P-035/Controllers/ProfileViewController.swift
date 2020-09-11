//
//  ProfileViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/11/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "User Profile"
        label.font = UIFont(name: "Avenir-Light", size: 25)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    private let BackButton: UIButton = {
        let button = UIButton()
        // button.setTitle("Back", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(showSettingsController), for: UIControl.Event.touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        LoadUI()
    }
    
    func LoadUI() {
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 15, width: 30, height: 25)
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40)
        
    }
    
    @objc func showSettingsController() {
        let set = SettingsViewController()
        set.modalPresentationStyle = .fullScreen
        present(set, animated: true, completion: {
            // Back
        })
    }

}
