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
        label.font = UIFont(name: "Avenir-Light", size: 32)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        
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
    
    private let addressTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Address", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Student", "Staff"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    private let signUpButton: AuthenticationUIButton = {
        let button = AuthenticationUIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
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
            
            //handle error
            
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            guard let controller = keyWindow?.rootViewController as? HomeViewController else { return }
            controller.configure()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - Functions
    func UI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(apptitleLabel)
        apptitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        apptitleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView,addressContainerView, passwordContainerView, accountTypeContainerView,signUpButton])
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
        guard let address = addressTextField.text else { return }
        let accountType = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("ERROR: Registration error \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = [
                "email": email,
                "fullName": fullName,
                "address": address,
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
            
//            guard let uid = result?.user.uid else { return }
//
//            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
//
//                print("Success: Successfuly Registerd...")
//            }
//        }
    
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
}


