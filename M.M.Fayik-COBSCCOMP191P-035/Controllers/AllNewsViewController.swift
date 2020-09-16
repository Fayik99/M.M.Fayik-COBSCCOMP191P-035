//
//  AllNewsViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/16/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore

class AllNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

     var tableView: UITableView!
     var newsList =  [String]()
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "All News"
        //label.font = UIFont(name: "Avenir-Light", size: 30)
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 27)
        label.textColor = UIColor.black
        
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
        
        Database.database().reference().child("notifications-news").observe(.value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = child.value as? [String : AnyObject] ?? [:]
                self.newsList.append(dict["news"] as! String)
                
                self.setTableView()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        cell.textLabel?.text = newsList[indexPath.row]
        return cell
    }
    
    func LoadUI() {
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        view.addSubview(BackButton)
        BackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, paddingTop: 5, paddingLeft: 12, width: 30, height: 25)
    
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView)
        
        tableView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
        
    }
    
    @objc func showUpdateController() {
        let home = TabBarViewController()
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true, completion: {
        })
    }
    
}
