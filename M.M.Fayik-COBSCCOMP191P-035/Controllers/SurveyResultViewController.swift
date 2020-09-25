//
//  SurveyResultViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/1/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SurveyResultViewController: UIViewController {
    var score: Int?
    var totalScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        setupViews()
        view.backgroundColor = UIColor.black
    }
    
    func showRating() {
        var rating = ""
        var color = UIColor.black
        guard let sc = score, let tc = totalScore else { return }
        let s = sc * 100 / tc
        if s < 10 {
            rating = "Survey Completed"
            color = UIColor.darkGray
        }  else if s < 40 {
            rating = "Survey Completed"
            color = UIColor.blue
        } else if s < 60 {
            rating = "Survey Completed"
            color = UIColor.red
        } else if s < 80 {
            rating = "Survey Completed"
            color = UIColor.red
        } else if s <= 100 {
            rating = "Survey Completed"
            color = UIColor.red
        }
        lblRating.text = "\(rating)"
        lblRating.textColor=color
    }
    
    @objc func btnSubmitAction() {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let sValue = score else { return }
        
        let values = [
            "surveyWeight": sValue,
            ] as [String : Any]
        
        Database.database().reference().child("users").child(userID).updateChildValues(values) { (error, ref) in
            
//            let ac = UIAlertController(title: "Survey", message: "Successfully submitted", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(ac, animated: true)
        }
            let submit = UpdateViewController()
            submit.modalPresentationStyle = .fullScreen
            present(submit, animated: true, completion: {
            })
            // self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupViews() {
        self.view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive=true
        lblTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblTitle.widthAnchor.constraint(equalToConstant: 250).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 80).isActive=true
        
        self.view.addSubview(lblScore)
        lblScore.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 0).isActive=true
        lblScore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblScore.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblScore.heightAnchor.constraint(equalToConstant: 60).isActive=true
        lblScore.text = "\(score!) / \(totalScore!)"
        
        self.view.addSubview(lblRating)
        lblRating.topAnchor.constraint(equalTo: lblScore.bottomAnchor, constant: 40).isActive=true
        lblRating.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblRating.widthAnchor.constraint(equalToConstant: 220).isActive=true
        lblRating.heightAnchor.constraint(equalToConstant: 60).isActive=true
        showRating()
        
        self.view.addSubview(btnSubmit)
        btnSubmit.topAnchor.constraint(equalTo: lblRating.bottomAnchor, constant: 40).isActive=true
        btnSubmit.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnSubmit.widthAnchor.constraint(equalToConstant: 150).isActive=true
        btnSubmit.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnSubmit.addTarget(self, action: #selector(btnSubmitAction), for: UIControl.Event.touchUpInside)
    }
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text="Your Result"
        lbl.textColor=UIColor.darkGray
        lbl.textAlignment = .center
        //lbl.font = UIFont.systemFont(ofSize: 46)
        lbl.font = UIFont(name:"Avenir-medium", size: 45)
        lbl.numberOfLines=2
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblScore: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.mainBlueTint
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblRating: UILabel = {
        let lbl=UILabel()
        lbl.text=""
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnSubmit: UIButton = {
        let btn = UIButton()
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange
        btn.layer.cornerRadius=5
        btn.clipsToBounds=true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
}
