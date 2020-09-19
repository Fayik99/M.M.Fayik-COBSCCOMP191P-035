//
//  SignUpViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/23/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GeoFire

class SignUpViewController: UIViewController {

    private var location = LocationHandling.shared.locationManager.location
    // MARK: - Properties
    private let apptitleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "NIBM COVID19"
        label.font = UIFont(name: "Avenir-medium", size: 32)
        label.textColor = UIColor(white: 0, alpha: 1.8)
        
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField )
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField )
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var indexContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: indexTextField )
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var addressContainerView: UIView = {
          let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: addressTextField )
          view.heightAnchor.constraint(equalToConstant: 50).isActive = true
          return view
      }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let fullNameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
    }()
    
    private let indexTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "IndexNo / EmployeeCode", isSecureTextEntry: false)
    }()
    
    private let addressTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Address", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Student", "Staff"])
        sc.backgroundColor = .rgb(red: 27, green: 101, blue: 102)
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    private let signUpButton: AuthUIButton = {
        let button = AuthUIButton(type: .system)
        button.setTitle("S I G N U P", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UI()
    }
    
    func uploadUserDataAndShowHomeController(uid: String, values: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
            
            
            print("Success: SignUp Successful")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions
    func UI() {
        view.backgroundColor = .rgb(red: 13, green: 93, blue: 95)
        
        view.addSubview(apptitleLabel)
        apptitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        apptitleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, indexContainerView , addressContainerView, passwordContainerView, accountTypeContainerView,signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: apptitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let indexNo = indexTextField.text else { return }
        guard let address = addressTextField.text else { return }
        let accountType = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if (error != nil) {
                let ac = UIAlertController(title: "Registration failed", message: "Please fill missing fields", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
                
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = [
                "email": email,
                "fullName": fullName,
                "address": address,
                "indexOrEmployeeCode": indexNo,
                "accountType": accountType
                ] as [String : Any]
            
            if accountType == 0 || accountType == 1 {
            
            let geoFire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
            guard let location = self.location else { return }
            
            geoFire.setLocation(location, forKey: uid, withCompletionBlock: { (error) in
                self.uploadUserDataAndShowHomeController(uid: uid, values: values)
            })
        }
        
        self.uploadUserDataAndShowHomeController(uid: uid, values: values)
    }
}

    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
}


