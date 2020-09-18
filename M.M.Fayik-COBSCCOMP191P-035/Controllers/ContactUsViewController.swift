//
//  ContactUsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/11/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Contact Us / About Us"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 27)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let BackButton: UIButton = {
        let button = UIButton()
        // button.setTitle("Back", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(showSettingsController), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    private let AboutLabel: UILabel = {
        
        let label = UILabel()
        label.text = "This is an iOS app designed and developed by Fayik Muzammil. This app will help everyone to identify nearby covid 19 patients and avoid going to those places. App will notify you by an alert. Also we provided safe actions that you need to follow and keep safe everyone from this pandemic."
        label.font = UIFont(name: "Avenir-medium", size: 17)
        label.textColor = UIColor.black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 6
        
        return label
    }()
    
    private let copyRightLabel: UILabel = {
        
        let label = UILabel()
        label.text = "All rights reserved 2020 Fayik Inc"
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 14)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGray6
        LoadUI()
    }
    
    func LoadUI() {
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
    
        view.addSubview(AboutLabel)
        AboutLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 15, paddingRight: 15, height: 190)
        
        view.addSubview(copyRightLabel)
        copyRightLabel.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)

        
    }
    
    @objc func showSettingsController() {
        let set = SettingsViewController()
        set.modalPresentationStyle = .fullScreen
        present(set, animated: true, completion: {
            // Back
        })
    }

}
