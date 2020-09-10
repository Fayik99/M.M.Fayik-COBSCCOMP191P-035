//
//  ContactUsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/11/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    private let BackButton: UIButton = {
        let button = UIButton()
        // button.setTitle("Back", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(showSettingsController), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        LoadUI()
    }
    
    func LoadUI() {
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 15, width: 30, height: 25)
        
        
    }
    
    @objc func showSettingsController() {
        let set = SettingsViewController()
        set.modalPresentationStyle = .fullScreen
        present(set, animated: true, completion: {
            // Back
        })
    }

}
