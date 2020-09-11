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
import LocalAuthentication

class LoginViewController: UIViewController {

     // MARK: - Properties
    private let apptitleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "NIBM COVID19"
        label.font = UIFont(name: "Avenir-Light", size: 32)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        
        return label
    }()
    
    private lazy var logoImage: UIImageView = {
        
       let imageView = UIImageView(image: #imageLiteral(resourceName: "NIBM-GOLD"))
       return imageView
        
    }()
    
    private lazy var emailContainerView: UIView = {
        
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
        
    }()
    
    private lazy var passwordContainerView: UIView = {
        
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
        
    }()
    
    
    private let emailTextField: UITextField = {
        
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
        
    }()
    
    private let passwordTextField: UITextField = {
        
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
        
    }()
    
    private let loginButton: AuthUIButton = {
        let button = AuthUIButton(type: .system)
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
        
        view.addSubview(logoImage)
        logoImage.anchor(top: apptitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 25, paddingRight: 25, width: 35, height: 140)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        view.addSubview(stack)
        
        stack.anchor(top: logoImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        
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
            if (error != nil) {
                //print("ERROR: Login Failed \(error.localizedDescription)")
                let ac = UIAlertController(title: "Login failed", message: "Incorrect email or password", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
                
                return
            }
            
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authentication Success"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            let ac = UIAlertController(title: "Authentication Success", message: "Access granted", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(ac, animated: true)
                        } else {
                            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(ac, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "Biometrics unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
            
            print("Success: Login Successful")
           // self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
                       
//            let keyWindow = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first


//            guard let controller = keyWindow?.rootViewController as? HomeViewController else { return }
//          controller.configure()
            
//            self.perform(#selector(self.tabBar), with: nil, afterDelay: 0.01)
//            self.perform(#selector(self.showHomeController), with: nil, afterDelay: 0.02)
            
             //self.dismiss(animated: true, completion: nil)
            
        }
    }
    // MARK: Functions
    @objc func handleShowSignUp() {
        
        let signUp = SignUpViewController()
        navigationController?.pushViewController(signUp, animated: true)
        
    // MARK: Navigate functions
    }
//    @objc func showHomeController() {
//        let home = HomeViewController()
//        home.modalPresentationStyle = .fullScreen
//        present(home, animated: true, completion: {
//            home.configure()
//        })
//    }
//    @objc func tabBar() {
//       let tab = TabBarViewController()
//        tab.modalPresentationStyle = .currentContext
//           present(tab, animated: true, completion: {
//               tab.tab()
//           })
//       }
}

