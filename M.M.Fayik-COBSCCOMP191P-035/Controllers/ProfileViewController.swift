//
//  ProfileViewController.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 9/11/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {

    var selectedImage: UIImage?
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "User Profile"
        label.font = UIFont(name: "Avenir-Light", size: 30)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont(name: "Avenir-Light", size: 24)
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

    private let updateButton: AuthUIButton = {
        
        let button = AuthUIButton(type: .system)
        button.setTitle("U P D A T E", for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(updateAll), for: UIControl.Event.touchUpInside)
        
        return button
        
    }()
    
    private lazy var profileImageView: UIImageView = {
        
        let pImage = UIImageView()
        pImage.image = #imageLiteral(resourceName: "icons8-image-100").withRenderingMode(.alwaysOriginal)
        pImage.contentMode = .scaleAspectFill
        pImage.layer.cornerRadius = 10
        pImage.clipsToBounds = true
        
        return pImage
        
    }()
    
    private let ActiveLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Active user since August 2020"
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    private let addressLabel: UILabel = {
         
         let label = UILabel()
         label.text = ""
         label.font = UIFont(name: "Avenir-Light", size: 15)
         label.textColor = UIColor.black
         label.textAlignment = .center
         
         return label
     }()
    
    private let tempLabel: UILabel = {
         
         let label = UILabel()
         label.text = ""
         label.font = UIFont(name: "Avenir-Light", size: 22)
         label.textColor = UIColor.black
         label.textAlignment = .center
         
         return label
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        LoadUI()
        uploadProfilePic()
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
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 35, paddingLeft: 150, paddingRight: 150, width: 90, height: 90)
        
        view.addSubview(ActiveLabel)
        ActiveLabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 90, paddingRight: 90)
        
        view.addSubview(addressLabel)
        addressLabel.anchor(top: ActiveLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 90, paddingRight: 90)
        
        view.addSubview(tempLabel)
        tempLabel.anchor(top: addressLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 90, paddingRight: 90)
        
        view.addSubview(updateButton)
        updateButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user name value
            let value = snapshot.value as? NSDictionary
            let name = value?["fullName"] as? String ?? ""
            let address = value?["address"] as? String ?? ""
            let temparature = value?["bodyTemperature"] as? String ?? ""
            self.nameLabel.text = name
            self.addressLabel.text = "at \(address)"
            self.tempLabel.text = temparature+"'C"
            
            // ...
        }) { (error) in
            print("Name not found")
        }
    }
    
    func uploadProfilePic() {
    
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGuesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func showSettingsController() {
        let set = SettingsViewController()
        set.modalPresentationStyle = .fullScreen
        present(set, animated: true, completion: {
            // Back
        })
    }
    
    @objc func updateAll() {
        
        let userID = Auth.auth().currentUser?.uid
        
        let storageRef = Storage.storage().reference(forURL:"gs://nibm-covid19.appspot.com/profilePics").child(userID!).child("\(NSUUID().uuidString).jpg")
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error ) in
                
                if error != nil{
                    print("Error in uploading profile photo.")
                }

                storageRef.downloadURL(completion: {(url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    else if url == nil{
                        print(error!.localizedDescription)
                        return
                    }
                    let pic = url?.absoluteString
                    
                    
                    let userdata = ["profilePicURL": pic as Any, ]
                    Database.database().reference().child("users").child((userID)!).updateChildValues(userdata) { (error, ref) in
                    
                       print("DEBUG: Data saved...")
                    }
                    
                })
            }
            )}
    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profileImageView.image = image
        }
        print(info)
        
        dismiss(animated: true, completion: nil)
    }
}
