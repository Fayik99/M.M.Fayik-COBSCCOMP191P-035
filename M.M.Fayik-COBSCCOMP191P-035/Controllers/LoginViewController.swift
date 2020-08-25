//
//  LoginViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/23/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

     // MARK: - Properties
    private let apptitleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "NIBM COVID19"
        label.font = UIFont(name: "Avenir-Light", size: 32)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-image-100"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
        
    }()
    
    private lazy var passwordContainerView: UIView = {
        
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "icons8-more-100"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
        
    }()
    
    
    private let emailTextField: UITextField = {
        
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
        
    }()
    
    private let passwordTextField: UITextField = {
        
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
        
    }()
    
    private let loginButton: AuthenticationUIButton = {
        let button = AuthenticationUIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        return button
        
    }()
    
    let dontHaveAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
    
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
        
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(apptitleLabel)
        apptitleLabel.translatesAutoresizingMaskIntoConstraints = false
        apptitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        apptitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        view.addSubview(stack)
        
        stack.anchor(top: apptitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
     // MARK: - Helper Functions
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
    }
    
     // MARK: Functions
     @objc func handleSignIn() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("ERROR: Login Failed \(error.localizedDescription)")
                return
            }
            
            print("Success: Login Successful")
            
                       
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            

            guard let controller = keyWindow?.rootViewController as? TabBarViewController else { return }
            controller.configureUi()
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    // MARK: Functions
    @objc func handleShowSignUp() {
        
        let signUp = SignUpViewController()
        navigationController?.pushViewController(signUp, animated: true)
    }
}

