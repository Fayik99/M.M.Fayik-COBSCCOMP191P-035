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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        LoadUI()
    }
    
     func LoadUI() {
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: BackButton.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 16)
        titleLabel.centerX(inView: view)
    
    }
    
    @objc func showUpdateController() {
        let submit = UpdateViewController()
        submit.modalPresentationStyle = .fullScreen
        present(submit, animated: true, completion: {
        })
    }
}
